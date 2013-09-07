#= require_self
#= require_tree ./models
#= require_tree ./templates
#= require_tree ./views

$ ->
  $(document).on 'mouseenter', '.tip', -> $(this).tooltip().tooltip('show')
  $(document).on 'mouseleave', '.tip', -> $(this).tooltip('hide')

App = window.App = {}

App.converter = new Showdown.converter()

v = {}
_.extend(v, Backbone.Events)

App.vent = v