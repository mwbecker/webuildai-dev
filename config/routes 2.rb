# frozen_string_literal: true

Rails.application.routes.draw do
  # resources :pairwise_comparisons
  # resources :scenarios
  # resources :categorical_data_options
  # resources :data_ranges
  # resources :participant_feature_weights
  # resources :participants
  resources :features
  # resources :sessions
  # resources :abouts
  # resources :evaluations

  root to: 'static#base'
  scope :react do
    get '/', to: 'static#index'
    get '/*path', to: 'static#index'
  end

  namespace :api do
    namespace :v1 do
      get 'features/get_all_features'
      get 'features/get_all_features_shuffled'
      post 'features/new_weight'
      post 'features/new_feature'
      post 'pairwise_comparisons/generate_pairwise_comparisons'
      post 'pairwise_comparisons/update_choice'
      get 'ranked_list/new'
      post 'ranked_list/generate_samples'
      post 'ranked_list/save_human_weights'
      get 'ranked_list/obtain_weights'

      post 'work_preference_overview'
      post 'sessions/login'
      post 'sessions/logout'
      post 'testing/reset'
    end
  end

  # get 'static/marco'
  # get 'ranked_list/ranked_list'
  # get 'ranked_list/preview'
  # get 'ranked_list/weights'
  # post 'ranked_list/update_human_ranks'
  # get 'ranked_list/generate_samples'
  # get 'ranked_list/done'
  # post 'ranked_list/reload'

  # get 'users/new', to: 'users#new', as: :signup
  # get 'user/edit', to: 'users#edit', as: :edit_current_user
  # get 'login', to: 'sessions#new', as: :login
  # get 'logout', to: 'sessions#destroy', as: :logout

  # post 'weighting', to: 'participant_feature_weights#weighting', as: :weighting
  # post 'new_how_ai', to: 'participant_feature_weights#new_how_ai', as: :new_how_ai
  # post 'new_how', to: 'pairwise_comparisons#new_how', as: :new_how
  # post 'store_info', to: 'evaluations#store_info', as: :store_info

  # post 'index_driver', to: 'pairwise_comparisons#index_driver', as: :index_driver
  # post 'ranked_list', to: 'pairwise_comparisons#ranked_list', as: :ranked_list

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
