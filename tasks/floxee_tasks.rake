
namespace :floxee do
  desc "Sync extra files from floxee plugin."
  task :sync do
    system "rsync -ruv vendor/plugins/floxee/db/migrate db"
    system "rsync -ruv vendor/plugins/floxee/public ."
  end
  
  desc "Load initial people from YAML file (in db/bootstrap/people.yml) into the system and retrieves their Twitter info"
  task :bootstrap => :environment do
    people = File.open(RAILS_ROOT+'/vendor/plugins/floxee/db/bootstrap/people.yml') {|file| YAML::load(file)}
    
    people.keys.each do |k|
      info = people[k]
      puts "Importing #{info['first_name']} #{info['last_name']}"
      if info['id']
        person = Person.find_or_create_by_id(info['id'])
        info.delete('id')
        person.update_attributes(info)
      else
        person = Person.create(info)
      end
    end
  end
  
  desc "Fetch stats from TwitterCounter and FollowCost"
  task :fetch_stats => :environment do
    User.all.each do |p|
      p.user.stats.sync if p.user and p.user.stats
    end
  end
  
  desc "Fetch latest Twitter statuses from search api"
  task :fetch_latest_tweets => :environment do
    Person.all.each do |p|
      p.user.fetch_latest_statuses if p.user
    end
  end
    
  desc "Fetch latest twitter user profile info from Twitter api"
  task :fetch_info => :environment do
    Person.all.each do |p|
      p.user.sync
    end
  end
  
  
end

