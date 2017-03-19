class AddUserToArtists < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :user, :reference
  end
end
