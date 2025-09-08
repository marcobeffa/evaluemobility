Rails.application.routes.draw do
  get "pages/intro"
  get "instruction", to: "pages#instruction"

  get "pages/help"
  get "pages/about"
  get "pages/professionisti"
  get "pages/privacy"
  get "pages/terms"
  get "pages/contact"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"


  resources :assessments, only: [ :create, :show ] do
    collection do
      get :start
      get :step        # Single step action with ?test=1,2,3...
      get :review
      post :update_step
    end
    member do
      get :result
    end
  end
  root "pages#intro"
  get "instruction", to: "pages#instruction"
  get "start", to: "assessments#start"
  get "terms", to: "pages#terms"
  get "privacy", to: "pages#privacy"
  get "cookies", to: "pages#cookies"
end
