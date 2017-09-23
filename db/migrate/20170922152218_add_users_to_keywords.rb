class AddUsersToKeywords < ActiveRecord::Migration[5.0]
  def change
    add_reference :keywords, :user, foreign_key: true
  end
end
