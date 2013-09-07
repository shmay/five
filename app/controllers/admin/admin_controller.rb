class Admin::AdminController < ActionController::Base
  protect_from_forgery
  layout 'admin'

  http_basic_authenticate_with :name => "dnd", :password => "pass1212"
end
