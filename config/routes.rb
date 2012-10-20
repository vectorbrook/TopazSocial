TopazSocial::Application.routes.draw do
  
  resources :interactions

  get "welcome/welcome" , :as => :welcome
  match "welcome/quick_find" => "welcome#quick_find"
  
  match "/employees"  => "users#employees" , :as => :employees
  match "/non_employees"  => "users#non_employees" , :as => :non_employees
  match "/edit_employee/:id"  => "users#edit_employee" , :as => :edit_employee

  match 'follow/:id'=> "users#follow" , :as => :follow
  match 'unfollow/:id'=> "users#unfollow" , :as => :unfollow
  match 'remove_follower/:id'=> "users#remove_follower" , :as => :remove_follower
  match 'accept/:id' => "users#accept" , :as => :accept
  match 'decline/:id' =>"users#decline" , :as => :decline

  match 'enable_user/:id' => "users#enable_user", :as => :enable_user
  match 'disable_user/:id' => "users#disable_user", :as => :disable_user

  match 'clear/:provider/:id' => "users#clear_provider_details", :as => :clear

  
  match "/social"  => "users#social" , :as => :social
  match "/do_tweet"  => "users#do_tweet" , :as => :do_tweet

  as :user do
      match '/user/confirmation' => 'users/confirmations#update', :via => :put, :as=> :update_user_confirmation
  end
  devise_for :users , :controllers => { :registrations => 'users/registrations', :confirmations => 'users/confirmations', :omniauth_callbacks => 'users/omniauth_callbacks' } do
    get "/login" => "users/sessions#new"
    get "/logout" => "users/sessions#destroy"
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  match "/enable_forum_category/:id" => "forum_categories#enable" , :as => :enable_forum_category
  match "/disable_forum_category/:id" => "forum_categories#disable" , :as => :disable_forum_category
  
  match "/enable_cm_page_category/:id" => "cm_page_categories#enable" , :as => :enable_cm_page_category
  match "/disable_cm_page_category/:id" => "cm_page_categories#disable" , :as => :disable_cm_page_category

  resources :forum_categories

  resources :forums do
    resources :forum_topics
  end
  
  resources :cm_page_categories
  resources :cm_pages
  
  match '/new_forum_topic_interaction/:id' => "interactions#new_for_forum_topic", :as => :new_forum_topic_interaction

  match "/add_forum/:fc_id" => "forums#new" , :as => :add_forum
  match "/enable_forum/:id" => "forums#enable" , :as => :enable_forum
  match "/disable_forum/:id" => "forums#disable" , :as => :disable_forum
  match "/approve_forum/:id" => "forums#approve" , :as => :approve_forum
  match "/reject_forum/:id" => "forums#reject" , :as => :reject_forum

  resources :customer_accounts do
    resources :customer_sites do
      resources :customer_contacts
    end
  end

  match "/enable_account/:id" => "customer_accounts#enable" , :as => :enable_account
  match "/disable_account/:id" => "customer_accounts#disable" , :as => :disable_account

  resources :service_cases
  match '/unassigned_cases' => "service_cases#unassigned_cases", :as => :unassigned_cases
  match '/assigned_cases' => "service_cases#assigned_cases", :as => :assigned_cases

  match "/enable_service_case/:id" => "service_cases#enable" , :as => :enable_service_case
  match "/disable_service_case/:id" => "service_cases#disable" , :as => :disable_service_case
  match '/add_interaction' => "service_cases#add_interaction" , :as => :add_interaction
  match '/assign_case(/:id)' => "service_cases#assign_case" , :as => :assign_case
  match '/add_log' => "service_cases#add_log" , :as => :add_log
  match "/my_cases"  => "service_cases#my_cases" , :as => :my_cases

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "welcome#welcome"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
