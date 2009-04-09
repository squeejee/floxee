class Status < ActiveRecord::Base
  belongs_to :user
  
  def person
    person = Person.find_by_user_id(self.user_id)
  end
  
  def organization
    
  end
  
end
