App = @App
_ = @_

App.UsersIndexView = Backbone.View.extend
  initialize: ->
    @games = @options.games
    @current_user_id = @options.current_user_id

  el: 'table#users'

  events:
    "click a.moar_games":"renderGames"
    "click a.invite":"inviteUser"

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

  inviteUser: (e) ->
    e.preventDefault()

    if confirm "Are you sure?  If not it's coo"
      target = @$(e.currentTarget)
      cell = target.closest('td')
      row = cell.closest('tr')
      table = row.closest('table')

      user_id = row.attr('id').match(/\d+/)[0]
      group_id = table.attr('data-invite-group-id')

      originalHtml = cell.html()
      cell.text('Inviting...')

      $.ajax
        url: "/users/#{user_id}/invite"
        data:
          inviter_id:@current_user_id
          group_id:group_id
        method: 'POST'
        dataType: 'json'
        success: (data) => cell.html("<b class='success'>Invite sent!</b>")
        error: (resp,data) =>
          message = resp.message || 'A server error occurred while trying to invite this user'
          alert(message)
          cell.html originalHtml
