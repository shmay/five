App = @App
_ = @_

App.SearchView = Backbone.View.extend
  el: '#search'
  events:
    "submit form":"submitForm"
  initialize: ->
    @games = @options.games
    @selectedGames = new App.GameList()
    selectedGameIds = @options.selected_game_ids
    if selectedGameIds and selectedGameIds.length
      @selectedGames.add(@games.get(gameId)) for gameId in selectedGameIds

    new App.GamesBoxView
      el: @$el
      collection:@games
      selectedGames: @selectedGames

  submitForm: (e) ->
    e.preventDefault()

    form = @$('form:first')

    if @selectedGames.length
      form.prepend "<input name='game_ids' type='hidden' value='#{@selectedGames.pluck('id').join(',')}' />"

    @$('input[type=submit]').val('Submitting...').attr('disabled', 'disabled')
    @$el.off 'submit form'
    form.submit()
