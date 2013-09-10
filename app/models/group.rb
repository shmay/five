class Group < ActiveRecord::Base
  has_one :location

  has_many :invites

  has_and_belongs_to_many :games
  has_and_belongs_to_many :events

  has_many :groupings
  has_many :users, through: :groupings

  def self.users_groups(user)
    select('groups.*',
      'groupings.created_at AS user_join_date',
      'locations.city AS city', 'locations.state AS state').
    joins(%{
      INNER JOIN "groupings" ON "groupings"."group_id" = "groups"."id" AND "groupings"."user_id" = #{user.id}
      LEFT JOIN "locations" ON "locations"."group_id" = "groups"."id"
    })
  end
end
