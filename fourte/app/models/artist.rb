class Artist < ApplicationRecord
  serialize :genres
  has_many :songs



end
