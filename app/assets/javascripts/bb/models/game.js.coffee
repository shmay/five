App = @App
Backbone = @Backbone
_ = @_

App.Game = Backbone.Model.extend()

App.GameList = Backbone.Collection.extend
  model: App.Game
  parse: (resp, xhr) ->
    @fetched = true
    resp
