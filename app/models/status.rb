class Status < ActiveRecord::Base
  belongs_to :user
  
  def person
    person = Person.find_by_user_id(self.user_id)
  end
  
  def organization
    
  end
  
  def self.paginate(options={})
    options[:per_page] ||= 10
    options[:page] ||= 1
     
    options[:per_page] = options[:per_page].to_i
    options[:page] = options[:page].to_i
    
    @tweets = Status.search(options)
    
    unless options[:screen_names].blank?
      @tweets = @tweets.select{|t| options[:screen_names].split(',').include?(t.from_user) }
    end
    @tweets.paginate(:page => options[:page], :per_page => options[:per_page])
  end
  
  def self.search(options={})
    #@tweets = Status.cached_by_id
    @tweets = Status.all(:order => options[:order])
    @tweets = @tweets.select{|t| t.text.downcase.include?(options[:q].downcase) } unless options[:q].blank? or @tweets.empty?
    @tweets
  end
  
  # def self.cached_by_id(force = false)
  #     Rails.cache.fetch('tweets', :force => force) {Status.by_id}
  #   end
  
end
