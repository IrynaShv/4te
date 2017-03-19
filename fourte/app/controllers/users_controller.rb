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
      unless country == 'unknown' || country == '' || country == 'US' || country == 'USA'
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

    # nodes.push({
    #     'id' => count,
    #     'type' => "USER",
    #     'name' => @user.name,
    #     'image' => @user.image_url
    #            })
    # count = count + 1

    genresID = {};
    artistTypeID = {};
    countryTypeID = {};

    @genres.each do |genre|
      nodes.push({
          'id' =>count,
          'class' => "GENRE",
          'type' => genre[0],
          'name' => genre[0],
          'occurences' => genre[1]
                     })
      genresID[genre[0]] = count
      # links.push({
      #     'source' => 0,
      #     'target' => count
      #            })

      count = count + 1
    end

    @artist_type.each do |artistType|
      nodes.push({
          'id' => count,
          'class' => "ARTIST_TYPE",
          'type' => artistType[0],
          'name' => artistType[0],
          'occurences' => artistType[1]
                 })
      artistTypeID[artistType[0]] = count

      count = count + 1
    end

    @countries.each do |country|
      nodes.push({
          'id' => count,
          'class' => "COUNTRY",
          'type' => country[0],
          'name' => country[0],
          'occurences' => country[1]
                 })

      countryTypeID[country[0]] = count

      count = count + 1
    end

    @user.artists.each do |artist|
      nodes.push({
          'id' => count,
          'class' => "ARTIST",
          'name' => artist.name})

      unless artist.genres == nil
        artist.genres.each do |genre|
          links.push({
                         'source' => genresID[genre],
                         'target' => count
                     })
        end
      end

      artist_type_of = artist.type_of_artist

      unless artist_type_of == 'unknown'
        links.push({
              'source' => artistTypeID[artist.type_of_artist],
              'target' => count
                     })
      end

      country = artist['origin'].gsub('[]', '')
      unless country == 'unknown' || country == '' || country == 'US' || country == 'USA' || country == 'U.S.'
        links.push({
            'source' => countryTypeID[country],
            'target' => count
                   })
      end
      count = count + 1
    end

    nodeJSON[:'nodes'] = nodes
    nodeJSON[:'links'] = links

    @fileJSON = JSON.generate(nodeJSON)


    genrePieChartJSON = {}
    tempGenrePieChart = []

    artistTypePieChartJSON = {}
    tempartistTypePieChart = []

    countryTypePieChartJSON = {}
    tempCountryPieChart = []

    for i in 0..2
      legend = @artist_type.keys[i]
      value = @artist_type[@artist_type.keys[i]]

      unless legend == nil || value == nil
      tempartistTypePieChart.push({
          'legend':@artist_type.keys[i],
          'value':@artist_type[@artist_type.keys[i]]
                                  })
        end
    end

    for i in 0..9
      tempGenrePieChart.push({
          'legend':@genres.keys[i],
          'value':@genres[@genres.keys[i]]
                             })
    end

    for i in 0..9
      legend = @countries.keys[i]
      value = @countries[@countries.keys[i]]

      unless legend == nil || value == nil
        tempCountryPieChart.push({
                                        'legend':legend,
                                        'value':value
                                    })
      end
    end
    genrePieChartJSON[:'data'] = tempGenrePieChart
    @genrePieChart = JSON.generate(genrePieChartJSON)

    artistTypePieChartJSON[:'data'] = tempartistTypePieChart
    @artistTypePieChart = JSON.generate(artistTypePieChartJSON)

    countryTypePieChartJSON[:'data'] = tempCountryPieChart
    @countryPieChart = JSON.generate(countryTypePieChartJSON)
  end

end
