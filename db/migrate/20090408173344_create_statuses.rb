class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer   :user_id
      t.string    :text
      t.string    :source
      t.integer   :in_reply_to_user_id
      t.string    :in_reply_to_screen_name
      t.integer   :in_reply_to_status_id
      t.boolean   :favorited
      t.boolean   :truncated

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
