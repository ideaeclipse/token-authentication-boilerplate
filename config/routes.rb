Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  post "login", to: "user#auth"
  get "test", to: "user#test"
  get "admin", to: "user#admin"
end
