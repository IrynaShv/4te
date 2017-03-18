class CreateArtists < ActiveRecord::Migration[5.0]
  def self.up
    create_table :artists do |t|
      t.string :name,  :null => false
      t.text :genres, :array => true, :default => []
      t.string :spotify_artist_id, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :artists
  end

end
