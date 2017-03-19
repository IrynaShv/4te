class AddTypeToArtist < ActiveRecord::Migration[5.0]
  def change
    add_column :artists, :type_of_artist, :string
    add_column :artists, :origin, :string
  end
end
