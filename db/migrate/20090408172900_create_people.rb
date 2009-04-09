class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :title
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :nickname
      t.string :name_suffix
      t.string :gender
      t.string :email
      t.string :website
      t.string :phone
      t.string :fax
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end
