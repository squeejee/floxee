# Floxee
module Floxee
  class Error < StandardError; end
 
  def self.config(environment=RAILS_ENV)
    @config ||= {}
    @config[environment] ||= YAML.load(File.open(RAILS_ROOT + '/config/floxee.yml').read)[environment]
  end
 
  def self.username
    config['username']
  end
  
  def self.password
    config['password']
  end
 
end