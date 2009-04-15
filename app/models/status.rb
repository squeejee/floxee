class Status < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10
  
  
  belongs_to :user
  
  def person
    person = Person.find_by_user_id(self.user_id)
  end
  
  def organization
    
  end
  
end
