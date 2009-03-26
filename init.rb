require 'floxee'

ActionView::Base.send :include, FloxeeHelper 
ActionController::Base.class_eval do 
  
  # gross hack for Memcached
  before_filter :load_models

  protected
    def load_models
      # gross hack for memcached
      Person
      TwitterStatus
      Signature
      Petition
      TwitterUserStats
    end
  
end