class TwitterStatus < MongoRecord::Base
  collection_name :twitter_statuses
  
  fields  :status_id
  fields  :text
  fields  :from_user_id
  fields  :from_user
  fields  :to_user_id
  fields  :to_user
  fields  :iso_language_code
  fields  :source
  fields  :profile_image_url
  fields  :person_id
  fields  :created_at
    
  def person
    contact
  end
  
  def contact
    Person.find(self.person_id)
  end
  
  def self.paginate(options={})
    options[:per_page] ||= 10
    options[:page] ||= 1
     
    options[:per_page] = options[:per_page].to_i
    options[:page] = options[:page].to_i
    
    if options[:q].blank?
      @tweets = TwitterStatus.find(:all, :order => "created_at DESC").to_a
    else
      @tweets = TwitterStatus.search(options)
    end
    
    # unless options[:screen_names].blank?
    #   @tweets = @tweets.find_by_screen_name(options[:screen_names])
    # end
    @tweets.paginate(:page => options[:page], :per_page => options[:per_page])
  end
  
  def self.search(options={})
    #@tweets = TwitterStatus.cached_by_id
    @tweets = TwitterStatus.find_all_by_text(/#{options[:q]}/, :order => "created_at DESC").to_a
   # @tweets = @tweets.select{|t| t.text.downcase.include?(options[:q]) } unless options[:q].blank?
    @tweets
  end
  
  def self.cached_by_id(force = false)
    Rails.cache.fetch('tweets', :force => force) {TwitterStatus.by_id}
  end

end
