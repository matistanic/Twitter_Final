Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :tweets do
    post 'like', to:"tweets#like"
    post 'retweet', to:"tweets#retweet"
  end
  devise_for :users
  root to:"tweets#index"

  scope '/api' do 
    get '/news', to: 'api#news', as: 'api_news'
    get '/:date1/:date2', to: 'api#tweets_between_dates', as: 'tweets_between_dates'
    post '/tweets', to: 'api#create_tweet', as: 'api_tweets'
  end 
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
