class AddReferencesToSongs < ActiveRecord::Migration[5.0]
  def change
    add_reference :songs, :user, foreign_key: true
  end
end
