App = @App
_ = @_

App.IndexView = Backbone.View.extend
  el: '#events'

App.UsersEventsView.mixin(App.IndexMixin)
