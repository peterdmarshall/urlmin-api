Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "application#home"
  post "/url", to: "urls#create"
  get "/url/:slug", to: "urls#show"
end
