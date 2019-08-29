Rails.application.routes.draw do
  resources :pairwise_comparisons
  resources :scenarios
  resources :categorical_data_options
  resources :data_ranges
  resources :participant_feature_weights
  resources :participants
  resources :features
  resources :sessions
  resources :abouts
  resources :evaluations

  get 'users/new', to: 'users#new', as: :signup
  get 'user/edit', to: 'users#edit', as: :edit_current_user
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout

  post 'weighting', to: 'participant_feature_weights#weighting', as: :weighting
  post 'new_how_ai', to: 'participant_feature_weights#new_how_ai', as: :new_how_ai
  post 'new_how', to: 'pairwise_comparisons#new_how', as: :new_how


  root :to => "pairwise_comparisons#new"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
