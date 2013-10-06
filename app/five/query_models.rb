module Five
  class Query
    def self.index(model,params,select,current_user)
      errors = []
      order_them = false
      game_ids = []
      loc = nil
      options = {}

      within = params[:within].to_i == 0 ? nil : params[:within].to_i
      zip = params[:zip].to_i == 0 ? nil : params[:zip]

      if zip
        loc = Geokit::Geocoders::Google3Geocoder.geocode zip
        order_them = true
      elsif user_signed_in? && current_user.location
        loc = Geokit::Geocoders::Google3Geocoder.geocode current_user.location.zip
      end

      if params[:game_ids]
        game_ids = params[:games].split(',')
      end

      invite_group = params[:invite_group].to_i
      if current_user && invite_group > 0
        if Grouping.where(group_id:params[:invite_group].to_i,user_id: current_user.id, admin:true).first
          options[:invite_group] = Group.find_by_id(invite_group)
        end
      end

      if loc && !loc.city
        errors << "Couldn't find that zip!  Query was not performed.  Thank you, come again."
      end

      if errors.empty?
        query = self.get_models(model,select,loc,game_ids,within,order_them,options)
      end

      return errors,query,within,loc,zip,game_ids
    end

    def self.get_models(model, select, location, game_ids, within, order_them, options)
      mc = model_class = model.constantize
      selects = ['locations.city AS city', 'locations.zip AS zip', 'array_agg(games) AS preloaded_game_ids'].<<(select).flatten
      query = mc.select(selects).
      joins(%{
        LEFT JOIN "locations" ON "locations"."#{model}_id" = "#{model}s"."id"
        LEFT JOIN "playings" ON "playings"."#{model}_id" = "#{model}s"."id"
        LEFT JOIN "games" ON "games"."id" = "playings"."game_id"
      }).
      group("users.id,locations.id")

      if location
        query = query.select("#{Location.distance_sql(location)} AS distance")
        if order_them
          query = query.order("distance asc")
        end
      end

      if (location && within) or game_ids.any?
        query = mc.select('*').from("(#{query.to_sql}) ss")

        if game_ids.any?
          joined_game_ids = game_ids.map {|gid| gid.to_i}.join(",")
          query = query.where("preloaded_game_ids && ARRAY[#{joined_game_ids}]")
        end

        if (location && within)
          query = query.where("distance <= ?", within)
        end
      end

      query = self.run_options(options)

      query,location
    end

    def self.run_options(query,options)
      if options[:invite_group]
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

      query
    end
  end
end
