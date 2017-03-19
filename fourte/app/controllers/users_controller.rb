class UsersController < ApplicationController

  def show
    @user = User.where(:id => params[:id]).first
  end


  def count_genres
    @genres =  {'hip hop' => 0, 'metal' => 0, 'pop' => 0, 'rap' => 0, 'jazz' => 0, 'indie' => 0, 'classical' => 0, 'alternative' => 0, 'screamo' => 0, 'rock' => 0, 'edm' => 0, 'techno' => 0,
                         'country' => 0, 'house' => 0, 'r&b' => 0, 'dubstep' => 0}

  end
end
