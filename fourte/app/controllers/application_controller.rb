class ApplicationController < ActionController::Base
  require 'net/http'
  require 'net/https'

  after_action :allow_iframe, only: :embed
  protect_from_forgery with: :exception
end
