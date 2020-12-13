Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  put '/packages/:tracking_id/track/', to: 'trackings#update'
end
