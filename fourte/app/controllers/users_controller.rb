class UsersController < ApplicationController

  def show
    @user = User.where(:id => params[:id]).first
    count_genres
    make_json
  end


  def count_genres
    genres =  {'hip hop' => 0, 'metal' => 0, 'pop' => 0, 'rap' => 0, 'jazz' => 0, 'indie' => 0, 'classical' => 0,
               'alternative' => 0, 'screamo' => 0, 'rock' => 0, 'edm' => 0, 'techno' => 0,
               'country' => 0, 'house' => 0, 'r&b' => 0, 'dubstep' => 0}

    countries = {}
    artist_type = {'solo male' => 0, 'solo female' => 0, 'band' => 0}
    @user.artists.each do |artist|
      if artist.genres != nil
        artist.genres.each do |genre|
          genres[genre] = genres[genre] + 1
        end
      end

      unless artist[:type_of_artist] == 'unknown'
        artist_type[artist[:type_of_artist]] = artist_type[artist[:type_of_artist]] + 1
      end
      country = artist['origin'].gsub('[]', '')
      unless country == 'unknown'
        if countries.has_key? country
          countries[country] = countries[country] + 1
        else
          countries[country] = 1
        end
      end
    end

    @genres = {}
    @countries = {}
    @artist_type = {}

    genres.keys.sort_by { |key| genres[key] }.reverse.each do
    |key|
      puts genres[key]
      @genres[key] = genres[key]
    end
    countries.keys.sort_by { |key| countries[key] }.reverse.each do
    |key|
      puts countries[key]
      @countries[key] = countries[key]
    end

    artist_type.keys.sort_by { |key| artist_type[key] }.reverse.each do
    |key|
      puts artist_type[key]
     @artist_type[key] = artist_type[key]
    end
  end

  def make_json
    nodeJSON = {}

    nodes = []
    links = []

    count = 0

    nodes.push({
        'id' => count,
        'type' => "USER",
        'name' => @user.name,
        'image' => @user.image_url
               })
    count = count + 1

    genresID = {};

    @genres.each do |genre|
      nodes.push({
          'id' =>count,
          'class' => "GENRE",
          'type' => genre[0],
          'name' => genre[0],
          'occurences' => genre[1]
                     })
      genresID[genre[0]] = count
      puts genresID[genre[0]]
      links.push({
          'source' => 0,
          'target' => count
                 })

      count = count + 1
    end

    @user.artists.each do |artist|
      nodes.push({
          'id' => count,
          'class' => "ARTIST",
          'name' => artist.name
                 });

      artist.genres.each do |genre|
        links.push({
                       'source' => genresID[genre],
                       'target' => count
                   })
      end

      count = count + 1
    end

    nodeJSON[:'nodes'] = nodes
    nodeJSON[:'links'] = links

    @fileJSON = JSON.generate(nodeJSON)
  end

end
