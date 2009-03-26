require 'floxee'

ActionView::Base.send :include, FloxeeHelper 
ActionController::Base.send :include, Floxee::ControllerMethods 