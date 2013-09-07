App = @App
_ = @_
converter = App.converter

App.ProfileView = Backbone.View.extend
  el: '#profile'

  infoTemplate: JST['bb/templates/users/info']
  errorsTemp: JST['bb/templates/misc/errors']
  mdExamples: JST['bb/templates/misc/markdown_examples']

  initialize: ->
    @id = @$el.attr('data-id')
    @info = @options.markdownInfo
    @name = ""

  events:
    "click i":"clickIcon"
    "click button":"clickButton"
    "click a.md_examples":"clickMdExamples"
    "blur input":"blurInput"
    "keydown input":"keydownInput"
    "keyup textarea":"keyupTextarea"

  clickIcon: (e) ->
    [target,col,id] = @getStuff(e)

    if target.hasClass('icon-pencil')
      if col.find('input').length or parent.find('textarea').length
        @closeCol(col,id)
      else
        @editCol(col,id)

  editCol: (col,id) ->
    entry = col.find('.entry')
    if id == 'name'
      @name = entry.text()
      html = "<input class='input' value='#{@name}'/>"
      entry.html(html)
      input = entry.find('input')
      input.focus()
    else if id == 'info'
      html = @infoTemplate
        markdownInfo:@info
        htmlInfo:@infoToHtml()

      entry.html(html)
      textarea = entry.find('textarea')
      textarea.focus()

  closeCol: (col,id) ->
    if id == "name"
      col.find('.entry').text @name
    else if id == "info"
      col.find('.entry').html "<div class='enclose_info'>#{@infoToHtml()}</div>"

  saveCol: (col,id) ->
    data = {user: {}}
    userData = data.user

    if id == "name"
      userData.name = col.find('input').val()
    else if id == "info"
      col.find('button').attr('disabled', 'disabled').first().text('Saving...')
      userData.info = @info = col.find('textarea').val()

    $.ajax
      url: "/users/#{@id}"
      method: 'PUT'
      dataType: 'json'
      data: data
      success: (resp) =>
        @[id] = resp[id]
        @closeCol(col,id)
        col.prepend("<div class='label label-success'>Successfully saved!</div>")
        setTimeout( ->
          col.find('.label-success').fadeOut()
        , 1000)
      error: (resp) =>
        @showErrors(col, id, resp.responseJSON)

  blurInput: (e) -> [target,col,id] = @getStuff(e)

  showErrors: (col, id, errors) -> parent.prepend @errorsTemp errors:errors

  infoToHtml: -> @infoHtml = converter.makeHtml(@info)

  keydownInput: (e) ->
    [target,col,id] = @getStuff(e)
    #esc
    if e.keyCode == 27
      @closeCol(col,id)
    #enter
    else if e.keyCode == 13
      @saveCol(col,id)

  getStuff: (e) ->
    target = @$(e.currentTarget)
    col = target.closest('.col')
    id = col.attr('id')

    [target,col,id]

  keyupTextarea: (e) ->
    [target,col,id] = @getStuff(e)

    #esc
    if e.keyCode == 27
      @closeCol(col,id)
    if id == 'info'
      @info = target.val()
      @infoToHtml()
      col.find('#preview_spot').html @infoHtml

  clickButton: (e) ->
    [target,col,id] = @getStuff(e)
    target_id = target.attr('id')

    if target_id == "saveInfo"
      @saveCol(col,id)
    else if target_id == "escInfo"
      @closeCol(col,id)

  clickMdExamples: (e) ->
    e.preventDefault()

    md_examples = @$('.markdown_examples')
    if md_examples.length
      if md_examples.css('display') == 'none'
        md_examples.slideDown()
      else
        md_examples.slideUp()
    else
      @$("#editInfo p:first").after(@mdExamples()).parent().find('.markdown_examples').slideDown()
