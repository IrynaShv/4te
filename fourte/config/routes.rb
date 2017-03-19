Rails.application.routes.draw do
  root :to => redirect('/login')
  resources :artists

  get '/login' => 'login#login'
  get '/prepare' => 'login#prepare'
  post '/loading' => 'login#loading'

  get '/users/:id', to: 'users#show'
end
