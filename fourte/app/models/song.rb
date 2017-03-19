class Song < ApplicationRecord
  attr_accessor :artist, :name, :spotify_song_id
  belongs_to :user
  has_one :artist

  def name

  end
end
