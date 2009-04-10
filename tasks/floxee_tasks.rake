
namespace :floxee do
  desc "Sync extra files from floxee plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/floxee/public ."
  end
  
  desc "Load initial people from YAML file (in db/bootstrap/people.yml) into the system and retrieves their Twitter info"
  task :bootstrap => :environment do
    people = File.open(RAILS_ROOT+'/vendor/plugins/floxee/db/bootstrap/people.yml') {|file| YAML::load(file)}
    
    people.values.each do |k|
      person = Person.new k
      person.save!
      person.fetch_latest_statuses
      person.fetch_info
      person.fetch_stats
    end
  end
  
  desc "Fetch stats from TwitterCounter and FollowCost"
  task :fetch_stats => :environment do
    Person.find(:all).each do |p|
      p.stats.fetch if p.stats
    end
  end
  
  desc "Fetch latest Twitter statuses from search api"
  task :fetch_tweets => :environment do
    Person.find(:all).each do |p|
      p.fetch_latest_statuses
    end
  end
    
  desc "Fetch latest twitter user profile info from Twitter api"
  task :fetch_info => :environment do
    Person.all.each do |p|
      p.fetch_info
    end
  end
  
  
end

