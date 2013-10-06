module IndexQuery
  extend ActiveSupport::Concern

  included do
    has_one :location
  end

  module ClassMethods
    def index(params,current_user)
      errors = []
      order_them = false
      game_ids = []
      loc = nil
      selected_games = []

      within = params[:within].to_i == 0 ? nil : params[:within].to_i
      zip = params[:zip].to_i == 0 ? nil : params[:zip]

      if zip
        loc = Geokit::Geocoders::Google3Geocoder.geocode zip
        order_them = true
      elsif current_user && current_user.location
        loc = Geokit::Geocoders::Google3Geocoder.geocode current_user.location.zip
      end

      if params[:game_ids]
        game_ids = params[:game_ids].split(',')
        selected_games = Game.where(id:game_ids)
      end

      if loc && !loc.city
        errors << "Couldn't find that zip!  Query was not performed.  Thank you, come again."
      end

      if errors.empty?
        query = self.get_models(loc,game_ids,within,order_them,current_user,params)
      end

      return errors,query,within,order_them,loc,zip,Game.all,selected_games
    end

    def get_models(location, game_ids, within, order_them, current_user, params)
      query = self

      model_string = self.to_s.downcase

      selects = ['locations.city AS city', 'locations.zip AS zip',
        'array_agg(distinct(games.id)) AS preloaded_game_ids'] + self.get_selects

      query = query.select(selects).
      joins(%{
        LEFT JOIN "locations" ON "locations"."#{model_string}_id" = "#{table_name}"."id"
        #{self.join_games}
      }).
      group("#{table_name}.id,locations.id")

      if location
        query = query.select("#{Location.distance_sql(location)} AS distance")
        if order_them
          query = query.order("distance asc")
        end
      end

      query = self.run_options(query,params,current_user)

      if (location && within) or game_ids.any?
        query = self.select('*').from("(#{query.to_sql}) ss")

        if game_ids.any?
          joined_game_ids = game_ids.map {|gid| gid.to_i}.join(",")
          query = query.where("preloaded_game_ids && ARRAY[#{joined_game_ids}]")
        end

        if (location && within)
          query = query.where("distance <= ?", within)
        end
      end

      return query
    end

    def run_options(query,params,current_user)
      if self == User
        invite_group = params[:invite_group].to_i
        if current_user && invite_group > 0
          if Grouping.where(group_id:params[:invite_group].to_i,user_id: current_user.id, admin:true).first
            group = Group.find_by_id(invite_group)
            if group
              invite_group = options[:invite_group]
              query = query.
              select("
                bool(count(invites.id) > 0) AS already_invited
              ").
              joins(%{
                LEFT JOIN "invites" ON "invites"."invitee_id" = "users"."id" AND "invites"."group_id" = #{invite_group.id}
                LEFT JOIN "groupings" ON "groupings"."user_id" = "users"."id" AND "groupings"."group_id" = #{invite_group.id}
              }).
              having(%{count(groupings.id) < 1})
            end
          end
        end
      elsif self == Group
        query = query.select("count(distinct(users.id)) AS members_count").
        joins(%{
          LEFT JOIN "groupings" ON "groupings"."group_id" = "groups"."id"
          LEFT JOIN "users" ON "users"."id" = "groupings"."user_id"
        })
      end

      query
    end

    def get_selects
      if self == User
        ['users.id AS id', 'users.name AS name', :current_sign_in_at]
      elsif self == Group
        ['groups.id AS id', 'groups.name AS name']
      elsif self == Event
        ['events.id AS id', 'events.title AS title', 'events.about AS about',
          'events.start_time AS start_time',  'events.finish_time AS finish_time']
      end
    end

    def join_games
      if self == User
        %{LEFT JOIN "playings" ON "playings"."user_id" = "users"."id"
          LEFT JOIN "games" ON "games"."id" = "playings"."game_id"}
      elsif self == Group
        %{LEFT JOIN "games_groups" ON "games_groups"."group_id" = "groups"."id"
          LEFT JOIN "games" ON "games"."id" = "games_groups"."game_id"}
      elsif self == Event
        %{LEFT JOIN "events_games" ON "events_games"."event_id" = "events"."id"
          LEFT JOIN "games" ON "games"."id" = "events_games"."game_id"}
      end
    end
  end
end
