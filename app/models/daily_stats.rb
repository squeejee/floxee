class DailyStats < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :report_date, :scope => :user_id
end
