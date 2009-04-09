class Person < ActiveRecord::Base
  belongs_to :user
  
  delegate :followers_count, :friends_count, :statuses_count, :profile_image_url, :description, :to => :user
  
  def display_name
    "#{nickname.blank? ? first_name : nickname} #{last_name}"
  end
  
  
  def screen_name=(value)
    self.user = User.find_or_create_by_screen_name(value)
  end
  
  def screen_name
    self.user.screen_name unless self.user.blank?
  end
  
  def tweets?
    not self.user.nil?
  end
end
