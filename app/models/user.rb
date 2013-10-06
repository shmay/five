class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  include IndexQuery
  validates :name, length: { minimum: 3 }

  has_many :invites

  has_many :playings
  has_many :games, through: :playings

  has_many :groupings
  has_many :groups, through: :groupings

  def owns_event?(event)
    id == event.user_id
  end

  def self.group_members(group)
    select(
      'users.id AS id', 'users.name AS name', :current_sign_in_at,
      "locations.city as city",
      "locations.zip as zip",
      "groupings.admin as is_group_admin",
      "array_agg(games.id) as preloaded_game_ids"
    ).
    joins(:groups).
    joins(%{
      LEFT JOIN "locations" ON "locations"."user_id" = "users"."id"
      LEFT JOIN "playings" ON "playings"."user_id" = "users"."id"
      LEFT JOIN "games" ON "games"."id" = "playings"."game_id"
    }).
    where('groups.id = ?', group.id).
    group("users.id,locations.id,groupings.admin")
  end

  def self.query_users(location,game_ids,within,order_them,invite_group)
    users = self
    distance_where_clause = nil
    games_where_clause = nil

    users = users.select(
      'users.id AS id', 'users.name AS name', :current_sign_in_at,
      "locations.city as city",
      "locations.zip as zip",
      "array_agg(games.id) as preloaded_game_ids"
    ).
    joins(%{
      LEFT JOIN "locations" ON "locations"."user_id" = "users"."id"
      LEFT JOIN "playings" ON "playings"."user_id" = "users"."id"
      LEFT JOIN "games" ON "games"."id" = "playings"."game_id"
    }).
    group("users.id,locations.id")

    if location
      users = users.select("#{Location.distance_sql(location)} AS distance")
      if order_them
        users = users.order("distance asc")
      end
    end

    if invite_group
      users = users.
        select("
          bool(count(invites.id) > 0) AS already_invited
        ").
        joins(%{
          LEFT JOIN "invites" ON "invites"."invitee_id" = "users"."id" AND "invites"."group_id" = #{invite_group.id}
          LEFT JOIN "groupings" ON "groupings"."user_id" = "users"."id" AND "groupings"."group_id" = #{invite_group.id}
        }).
        having(%{count(groupings.id) < 1})
    end

    if (location && within) or game_ids.any?
      users = User.select('*').from("(#{users.to_sql}) ss")

      if game_ids.any?
        joined_game_ids = game_ids.map {|gid| gid.to_i}.join(",")
        users = users.where("preloaded_game_ids && ARRAY[#{joined_game_ids}]")
      end

      if (location && within)
        users = users.where("distance <= ?", within)
      end
    end


    users
  end

end
