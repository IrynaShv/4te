class Artist < ApplicationRecord
  serialize :genres
  has_many :songs
  belongs_to :user


end
