# Floxee
module Floxee
  class Error < StandardError; end

  def self.config(environment=RAILS_ENV)
    @config ||= {}
    @config[environment] ||= YAML.load(File.open(RAILS_ROOT + '/config/floxee.yml').read)[environment]
  end

  def self.server
    config['server'] || 'http://127.0.0.1:5984/floxee'    
  end
  
  module ControllerMethods
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
end