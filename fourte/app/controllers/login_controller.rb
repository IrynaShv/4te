require 'httparty'
class LoginController < ApplicationController

  def login
  end

  def prepare
    @token = params[:access_token]
  end

  def loading
    access_token = params["hash"].split('=')[1].split("&").first
    items = []
    puts access_token
    user = HTTParty.get("https://api.spotify.com/v1/me", :headers => { "Authorization" => "Bearer " + access_token})

    user = JSON.parse user.body
    user = get_user(user["id"])

    res = HTTParty.get("https://api.spotify.com/v1/me/tracks", :headers => { "Authorization" => "Bearer " + access_token})
    hash = JSON.parse res.body
    puts hash
    hash["items"].each do |item|
      items << item
    end
    while hash["next"] != nil do
      url = hash["next"]
      res = HTTParty.get(url, :headers => { "Authorization" => "Bearer " + access_token})
      hash = JSON.parse res.body
      hash["items"].each do |item|
        items << item
      end
    end

    items.each do |item|
      item["track"]["artists"].each do |artist|
        name = artist["name"]
        puts name
        spotify_id = artist["id"]
        puts spotify_id
        artist = Artist.where(:spotify_artist_id => spotify_id).first
        puts artist
        if artist == nil
          res = HTTParty.get("https://api.spotify.com/v1/artists/#{spotify_id}")
          artist_info = JSON.parse res.body
          genres = filter_genres(artist_info["genres"])
          puts genres
          Artist.create(:name => name, :spotify_artist_id => spotify_id, :genres => genres, :user_id => user.id)
        end
      end
    end;nil
  end


  def get_user(id)
    user = User.all.where(:name => id).first
    if user.nil?
      user = User.new(:name => id)
      user.save!
    end
    user
  end


  def filter_genres(spotify_genres)
    genres = ['hip hop', 'metal', 'pop', 'rap', 'jazz', 'indie', 'classical', 'alternative', 'screamo', 'rock', 'edm', 'techno',
              'country', 'house', 'r&b', 'dubstep']
    real_genres = []
    spotify_genres.each do |sg|
      genres.each do |g|
        if sg =~/#{g}/i && !real_genres.include?(g)
          real_genres << g
        end
      end
    end

    return real_genres
  end

end
