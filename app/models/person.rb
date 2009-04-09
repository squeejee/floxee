class Person < ActiveRecord::Base
  has_friendly_id :display_name, :use_slug => true
  
  belongs_to :user
  
  delegate :followers_count, :friends_count, :statuses_count, :profile_image_url, :description, :to => :user
  
  validates_presence_of :first_name, :on => :create, :message => "can't be blank"
  
  def display_name
    "#{nickname.blank? ? first_name : nickname} #{last_name}"
  end
  
  
  def screen_name=(value)
    u = User.find_or_create_by_screen_name(value)
    # The rescue clause in the function above returns
    # "Could not retrieve user" if it doesn't find one, so check type
    if u.is_a?(User)
      self.user = u
      self.save
    end
  end
  
  def screen_name
    self.user.screen_name unless self.user.blank?
  end
  
  def tweets?
    not self.user.nil?
  end
end
