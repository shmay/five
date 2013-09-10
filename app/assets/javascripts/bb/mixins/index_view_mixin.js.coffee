App = @App
_ = @_

App.IndexMixin =
  initialize: ->
    @games = @options.games

  events:
    "click a.moar_games":"renderGames"
    "click a.invite":"inviteUser"

  methods:
    renderGames: (e) ->
      e.preventDefault()
      target = @$(e.currentTarget)
      row = target.closest('tr')
      cell = target.closest('td')
      game_ids = row.attr('data-game-id').split(',')

      html = ""

      for id,index in game_ids
        game = @games.get id
        html += " <a href='/games/#{game.get('slug')}'>#{game.get('name')}</a>"
        if index + 1 != game_ids.length
          if index + 2 == game_ids.length
            html += " &"
          else
            html += ", "

      cell.html html
