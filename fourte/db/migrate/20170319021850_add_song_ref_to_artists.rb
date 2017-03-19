class AddSongRefToArtists < ActiveRecord::Migration[5.0]
  def change
    add_reference :artists, :song, foreign_key: true
  end
end
