#= require_self
#= require_tree ./templates
#= require_tree ./mixins
#= require_tree ./models
#= require_tree ./views

_ = @_
App = @App

$ ->
  $(document).on 'mouseenter', '.tip', -> $(this).tooltip().tooltip('show')
  $(document).on 'mouseleave', '.tip', -> $(this).tooltip('hide')

App = window.App = {}

App.converter = new Showdown.converter()

v = {}
_.extend(v, Backbone.Events)

App.vent = v

Backbone.View.mixin = (mixin) ->
  proto = @prototype

  if !proto.events
    proto.events = {}

  _.extend proto.events, mixin.events
  _.extend proto, mixin.methods

  proto.initialize = _.wrap proto.initialize, (initialize) ->
    initialize.call(this)
    mixin.initialize.call(this)
