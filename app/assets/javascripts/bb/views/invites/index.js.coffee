App = @App
_ = @_

App.InvitesIndexView = Backbone.View.extend
  el: '#invitations'

  events:
    "click a.revoke_invite":"revokeInvite"

  revokeInvite: (e) ->
    e.preventDefault()
    if confirm "Are you sure?"
      target = @$(e.currentTarget)
      cell = target.closest('td')
      row = cell.closest('tr')
      invite_id = row.attr('id').match(/\d+/)[0]

      html = cell.html()
      cell.text('Revoking...')

      $.ajax
        url: "/invites/#{invite_id}"
        method: 'DELETE'
        dataType: 'json'
        success: (data) =>
          cell.text 'Revokage!'
          row.fadeOut()
          span = @$('span.invite_count')
          span.text(parseInt(span.text()) - 1)
        error: ->
          alert('My b.  Server occurred error while trying to revoke invite')
          cell.html html
