App = @App
_ = @_

App.GamesBoxView = Backbone.View.extend
  events:
    "click i":"clickIcon"

  initialize: ->
    _.bindAll this, 'gameSelected', 'addGame', 'removeGame'

    @selectedGames = @options.selectedGames

    @selectedGames.on 'add', @addGame
    @selectedGames.on 'remove', @removeGame

    input = @input = $('input.games-typeahead')

    input.typeahead
      name: 'accounts'
      local: @collection.pluck('name')

    input.on 'typeahead:selected', @gameSelected

  gameSelected: (event, selected) ->
    game = @collection.where(name:selected.value)[0]

    @input.typeahead 'setQuery', ''

    @selectedGames.add(game)

  addGame: (game) ->
    gameList = @$('#game_list')
    titleBar = gameList.find('#game-title-bar')

    if titleBar.css('display') == 'none' then titleBar.removeClass('hide').show()

    gameList.append @renderGame(game)
    @input.focus()

  renderGame: (game) ->
    "<span id='game_#{game.id}' class='game_entry label label-primary'>
       <a target='_blank' href='/games/#{game.get('slug')}'>#{game.get('name')}</a>
       <i style='margin-left:3px' class='pointer icon icon-remove'></i>
     </span>"

  removeGame: (game) ->
    if !@selectedGames.length
      @$('#game-title-bar').hide()

    @$("#game_#{game.id}").remove()

  clickIcon: (e) ->
    target = @$(e.currentTarget)

    if target.hasClass('icon-remove')
      id = target.closest('.game_entry').attr('id').match(/\d+/)
      @selectedGames.remove id
