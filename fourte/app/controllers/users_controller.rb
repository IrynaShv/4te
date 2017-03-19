class UsersController < ApplicationController
  before_filter :set_var

  def show
    puts params[:id]
    @user = User.where(:id => params[:id]).first
    puts @user.name
  end


  def count_genres

  end
end
