class CreateSongs < ActiveRecord::Migration[5.0]
  def self.up
    create_table :songs do |t|
      t.string :name, :null => false
      t.string :artist_name, :null => false
      t.string :spotify_song_id, :null => false
      t.integer :song_length

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
