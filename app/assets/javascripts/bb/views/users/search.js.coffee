App = @App
_ = @_

App.UsersSearchView = Backbone.View.extend
  el: '#users_search'
  events:
    "submit form":"submitForm"
  initialize: ->
    @games = @options.games
    @selectedGames = new App.GameList()
    gameIds = @options.game_ids
    if gameIds and gameIds.length
      @selectedGames.add(@games.get(gameId)) for gameId in gameIds

    new App.GamesBoxView
      el: @$el
      collection:@games
      selectedGames: @selectedGames

  submitForm: (e) ->
    e.preventDefault()

    form = @$('form:first')

    form.prepend "<input name='games' type='hidden' value='#{@selectedGames.pluck('id').join(',')}' />"

    @$('input[name=commit]').val('Submitting...').attr('disabled', 'disabled')
    @$el.off 'submit form'
    form.submit()
