class TwitterStatus < CouchRest::ExtendedDocument
  use_database CouchRest.database!(Floxee.server)
  
  property  :id
  property  :text
  property  :from_user_id
  property  :from_user
  property  :to_user_id
  property  :to_user
  property  :iso_language_code
  property  :source
  property  :profile_image_url
  property  :person_id
  property  :created_at, :cast_as => Time
  
  view_by :id, :descending => true
  view_by :from_user
  
  def person
    Rails.cache.fetch("people-#{self.person_id}", :expires_in => 60*10) {Person.get(self.person_id)}
  end
  
  def self.paginate(options={})
    options[:per_page] ||= 10
    options[:page] ||= 1
     
    options[:per_page] = options[:per_page].to_i
    options[:page] = options[:page].to_i
    
    @tweets = TwitterStatus.search(options[:q])
    
    unless options[:screen_names].blank?
      @tweets = @tweets.select{|t| options[:screen_names].split(',').include?(t.from_user) }
    end
    @tweets.paginate(:page => options[:page], :per_page => options[:per_page])
  end
  
  def self.search(q)
    @tweets = Rails.cache.fetch('tweets', :expires_in => 60*60*6) {TwitterStatus.by_id}
    @tweets = @tweets.select{|t| t.text.downcase.include?(q) } unless q.blank?
    @tweets
  end

end
