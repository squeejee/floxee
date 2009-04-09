class Person < MongoRecord::Base
  collection_name :people
  
  fields :title
  fields :first_name
  fields :middle_name
  fields :last_name
  fields :nickname
  fields :name_suffix
  fields :gender
  fields :email
  fields :website
  fields :phone
  fields :fax
  
  # twitter api properties
  fields :name
  fields :screen_name
  fields :location
  fields :description
  fields :profile_image_url
  fields :url
  fields :protected
  fields :followers_count
  fields :profile_background_color
  fields :profile_text_color
  fields :profile_link_color
  fields :profile_sidebar_fill_color
  fields :profile_sidebar_border_color
  fields :friends_count
  fields :favourites_count
  fields :utc_offset
  fields :statuses_count
  fields :created_at
  
  has_many :statuses, :class_name => 'TwitterStatus'
  has_one :stats, :class_name => 'TwitterUserStats'
    
  def display_name
    "#{self.first_name} #{self.last_name}"
  end
  
  def id_ordinal
    self.id.gsub(self.display_name.to_url,"").gsub("-", "").to_i
  end
  
  def tweets?
    not self.screen_name.blank?
  end
  
  def fetch_info
    unless self.screen_name.nil?
      begin
        user = JSON.parse(Net::HTTP.get(URI.parse("http://twitter.com/users/show/#{self.screen_name}.json")))
        self.update_attributes(user) if user
      # rescue
      #   puts "Problem getting Twitter info for #{self.display_name}"
      end
    end
  end
  
  def fetch_stats
    unless self.screen_name.nil?
      begin
        self.stats = []
        stats = TwitterUserStats.fetch(self.screen_name)
        self.stats = stats
        self.save
#      rescue
#        puts "Problem getting TwitterCounter stats for #{self.display_name}"
      end
    end
  end
  

  def fetch_latest_statuses
    unless self.screen_name.nil?
      begin
        if self.statuses.blank?
          # self.statuses = []
          # multiple calls to get all statuses
          page_count = (self.statuses_count.to_i/100) + 1
          (1..(page_count)).each do |page|
            search = Twitter::Search.new.from(self.screen_name).page(page).per_page(100).fetch()
            #self.statuses.concat search['results']
            search['results'].each do |tweet|
              ts = TwitterStatus.new(tweet)
              ts.person_id = self.id
              ts.status_id = ts.id
              ts.id = ""
              ts.save
              self.statuses << ts
              self.save
            end
          end      
        else
          last_id = self.statuses.map{|status| status.status_id}.max
          search = Twitter::Search.new.from(self.screen_name).since(last_id).fetch()
          #self.statuses.concat(search['results']).uniq!      
          search['results'].each do |tweet|
            ts = TwitterStatus.new(tweet)
            ts.person_id = self.id
            ts.status_id = ts.id
            ts.id = ""
            ts.save
            self.statuses << ts
            self.save
          end
        end
        # Refresh the TwitterStatus cache if new results are returned
 #       TwitterStatus.cached_by_id(true) if search['results'].size > 0
#      rescue
#        puts "Problem getting tweets for #{self.display_name}"
      end
    end
  end
  
  def self.paginate(options={})
    options[:sort] ||= 'last_name'
    
    options[:per_page] ||= 10
    options[:page] ||= 1
     
    options[:per_page] = options[:per_page].to_i
    options[:page] = options[:page].to_i
    
    if %w{statuses_count followers_count}.include?(options[:sort])
      @people = Person.find(:all, :conditions=>{:first_name=>/#{options[:q]}/i}).sort_by{|p| p[options[:sort]].to_i}
    else
      @people = Person.find(:all, :conditions=>{:first_name=>/#{options[:q]}/i}).sort_by{|p| p[options[:sort]].to_s}
    end
    @people.reverse! unless (options[:reverse].to_s == "true" or options[:reverse].blank?)
    @people.paginate(:page => options[:page], :per_page => options[:per_page])
  end
  
  def self.search(options={})
    @people = Person.find(:all)
    @people = @people.select{|p| p.display_name.downcase.include?(options[:q]) } unless options[:q].blank?
    @people
  end
  
  def self.most_followers_last_seven_days
    people_with_stats =  Person.find(:all, :select=>[:profile_image_url, :first_name, :last_name, :stats]).select{|p| !p.stats.nil?}
    people_with_stats.sort_by{|p| p.stats.followers_change_last_seven_days.to_i}.reverse[0..9].map{|p| [p, p.stats.followers_change_last_seven_days]}.reverse
  end
  
  def self.most_followers_last_thirty_days
    people_with_stats =  Person.find(:all, :select=>[:profile_image_url, :first_name, :last_name, :stats]).select{|p| !p.stats.nil?}
    people_with_stats.sort_by{|p| p.stats.followers_change_last_thirty_days.to_i}.reverse[0..9].map{|p| [p, p.stats.followers_change_last_thirty_days]}.reverse
  end

  def generate_unique_id
    unique_id = self.display_name.to_url
    people = Person.find(:all).select {|person| person.id.include?(unique_id)}
    if people.empty?
      unique_id
    else
      max_ordinal = people.map {|person| person.id_ordinal}.max
      unique_id + "-" + (max_ordinal + 1).to_s
    end
  end
  
  def twitter_api_fetch
    search = Twitter::Search.new.from(self.screen_name).fetch()['results']
  end
  
end