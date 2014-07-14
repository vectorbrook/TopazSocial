Ts1::Application.routes.draw do
  get "welcome/welcome"
  get "welcome/quick_find" => "welcome#quick_find"

  get "/employees"  => "users#employees" , :as => :employees
  get "/non_employees"  => "users#non_employees" , :as => :non_employees
  get "/edit_employee/:id"  => "users#edit_employee" , :as => :edit_employee
  put "/edit_employee/:id"  => "users#edit_employee"
  
  get "/customers"  => "users#customers" , :as => :customers

  get 'enable_user/:id' => "users#enable_user", :as => :enable_user
  get 'disable_user/:id' => "users#disable_user", :as => :disable_user

  get 'clear/:provider/:id' => "users#clear_provider_details", :as => :clear
  
  
  get "/social"  => "social_media#social" , :as => :social
  get "/do_tweet"  => "social_media#do_tweet" , :as => :do_tweet
  get "/find_users" => "users#find_users", :as => :find_users
  get "follow/:id"  => "users#follow" , :as => :follow
  get 'unfollow/:id' => 'users#unfollow', :as => :unfollow
  get 'block_user/:id' => 'users#block_user', :as => :block_user
  get 'show_profile/:id' => 'users#show_profile', :as => :show_profile 
    
  as :user do
      patch '/user/confirmation' => 'users/confirmations#update', :via => :patch, :as => :update_user_confirmation
  end
  
  devise_for :users,  :controllers => {:registrations => 'users/registrations', :confirmations => 'users/confirmations', :omniauth_callbacks => 'users/omniauth_callbacks' }
  devise_scope :user do
    get "/login", :to => "users/sessions#new"
    get "/logout", :to => "users/sessions#destroy"
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  resources :users
  
  resources :forums do
    resources :forum_topics do
         get '/addto_service/:id' => 'forum_posts#addto_service', :as => :forum_post_addto_service
         post '/addto_service/:id' => 'forum_posts#addto_service'
       resources :forum_posts

    end
  end
 

  resources :customer_accounts do
    resources :customer_sites do
      resources :customer_contacts
    end
  end
  resources :service_cases 
  get '/unassigned_cases' => "service_cases#unassigned_cases", :as => :unassigned_cases
  get '/assigned_cases' => "service_cases#assigned_cases", :as => :assigned_cases

  get "/enable_service_case/:id" => "service_cases#enable" , :as => :enable_service_case
  get "/disable_service_case/:id" => "service_cases#disable" , :as => :disable_service_case
  get '/add_interaction' => "service_cases#add_interaction" , :as => :add_interaction
  post '/add_interaction' => "service_cases#add_interaction"
  get '/assign_case(/:id)' => "service_cases#assign_case" , :as => :assign_case
  post '/assign_case(/:id)' => "service_cases#assign_case"
  get '/add_log' => "service_cases#add_log" , :as => :add_log
  post '/add_log' => "service_cases#add_log"
  get "/my_cases"  => "service_cases#my_cases" , :as => :my_cases

  resources :sales_leads 
  get '/unassigned_leads' => "sales_leads#unassigned_leads", :as => :unassigned_leads
  get '/assigned_leads' => "sales_leads#assigned_leads", :as => :assigned_leads

  get '/add_lead_interaction' => "sales_leads#add_lead_interaction" , :as => :add_lead_interaction
  post '/add_lead_interaction' => "sales_leads#add_lead_interaction"
  get '/assign_lead(/:id)' => "sales_leads#assign_lead" , :as => :assign_lead
  post '/assign_lead(/:id)' => "sales_leads#assign_lead"
  get '/add_lead_log' => "sales_leads#add_lead_log" , :as => :add_lead_log
  post '/add_lead_log' => "sales_leads#add_lead_log"
  get "/my_leads"  => "sales_leads#my_leads" , :as => :my_leads
  
  
  resources :sales_opportunities
  get '/unassigned_opportunities' => "sales_opportunities#unassigned_opportunities", :as => :unassigned_opportunities
  get '/assigned_opportunities' => "sales_opportunities#assigned_opportunities", :as => :assigned_opportunities

  get '/add_opportunity_interaction' => "sales_opportunities#add_opportunity_interaction" , :as => :add_opportunity_interaction
  post '/add_opportunity_interaction' => "sales_opportunities#add_opportunity_interaction"
  get '/assign_opportunity(/:id)' => "sales_opportunities#assign_opportunity" , :as => :assign_opportunity
  post '/assign_opportunity(/:id)' => "sales_opportunities#assign_opportunity"
  get '/add_opportunity_log' => "sales_opportunities#add_opportunity_log" , :as => :add_opportunity_log
  post '/add_opportunity_log' => "sales_opportunities#add_opportunity_log"
  get "/my_opportunities"  => "sales_opportunities#my_opportunities" , :as => :my_opportunities
  
  get "/enable_km_page_category/:id" => "km_page_categories#enable" , :as => :enable_km_page_category
  get "/disable_km_page_category/:id" => "km_page_categories#disable" , :as => :disable_km_page_category 
  resources :km_page_categories do 
    resources :km_pages
  end  

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  # You can have the root of your site routed with "root"
  root 'welcome#welcome'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
