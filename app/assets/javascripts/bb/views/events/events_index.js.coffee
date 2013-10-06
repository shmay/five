App = @App
_ = @_

App.EventsView = Backbone.View.extend
  el: '#events'

App.EventsView.mixin(App.IndexMixin)
