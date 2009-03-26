require 'floxee'

ApplicationContoller.class_eval do
  
  helper :floxee
  
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