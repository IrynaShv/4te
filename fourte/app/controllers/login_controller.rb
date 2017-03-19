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

    create_artists(items, user)
  end

  def create_artists(items, user)

    types = ['solo male', 'solo female', 'band']

  items.each do |item|
      item["track"]["artists"].each do |artist|
        name = artist["name"]
        puts name
        spotify_id = artist["id"]
        puts spotify_id
        artist = Artist.where(:spotify_artist_id => spotify_id).first
        puts artist
        if artist == nil
          genre_data = HTTParty.get("https://api.spotify.com/v1/artists/#{spotify_id}")
          artist_info = JSON.parse genre_data.body
          if name.force_encoding("UTF-8").ascii_only?
            other_data = HTTParty.get("http://ec2-54-237-206-73.compute-1.amazonaws.com/?name=#{name}")
            genres = filter_genres(artist_info["genres"])
            begin
                data = JSON.parse other_data
                puts data
                other_data_hash = filter_other_data(data)

            rescue JSON::ParserError => e
              puts "Error #{e}"
              other_data_hash = {:type => 'unknown', :origin => 'unknown'}
            end
          else
            other_data_hash = {:type => 'unknown', :origin => 'unknown'}
          end
          puts other_data_hash
          puts genres
          Artist.create(:name => name, :spotify_artist_id => spotify_id, :genres => genres, :user_id => user.id,
                        :origin => other_data_hash[:origin], :type_of_artist => other_data_hash[:type])
        end
      end
    end
  end

  def get_user(id)
    user = User.all.where(:name => id).first
    if user.nil?
      user = User.new(:name => id)
      user.save!
    end
    user
  end

  def filter_other_data(data)
      if data.has_key?('type')
        type = data['type']
        if type == 'solo'
          if data.has_key?('gender')
            gender = data['gender']
            if gender == 'female'
              type = 'solo female'
            elsif gender == 'male'
              type = 'solo male'
            else
              type = 'unknown'
            end
          end
        elsif type == 'band'
          type = 'band'
        else
          type = 'unknown'
        end

      else
        type = 'unknown'
    end

    if data.has_key?('origin')
      origin = data['origin']
    else
      origin = 'unknown'
    end
    return {:type => type, :origin => origin}
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
