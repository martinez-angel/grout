Grout::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :brands
      resources :posts
      resources :page_level_metrics
      resources :post_data
      end
    end
  end
