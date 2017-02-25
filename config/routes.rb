Rails.application.routes.draw do

  root to: 'projects#index'
  
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
