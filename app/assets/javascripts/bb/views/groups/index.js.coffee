App = @App
_ = @_

App.GroupsView = Backbone.View.extend
  el: '#groups'

  events:
    "click .join":"clickJoin"

  clickJoin: (e) ->
    e.preventDefault()
    target = @$(e.currentTarget)

    td = target.closest('td')
    td.text('Joining...')

    id = td.closest('.group').attr('id').match(/\d+/)

    $.ajax
      url: "/groups/#{id}/join"
      dataType: 'json'
      success: ->
        td.html "<a href='#' class='leave'>leave</a>"
      error: ->
        alert('group could not be joined')
