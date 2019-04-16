Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "auth_test", to: "user#auth_test"
  get "admin_test", to: "user#admin_test"

  post "login", to: "user#login"
  post "createuser", to: "user#create_user"
end
