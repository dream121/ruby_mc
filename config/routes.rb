Masterclass::Application.routes.draw do

  resources :password_resets, only: [:new, :edit, :create, :update]
  resources :experiment_values, except: [:show]

  root                  to: 'pages#root'
  get '/terms',         to: 'pages#terms'
  get '/privacy',       to: 'pages#privacy'
  get '/contact',       to: 'pages#contact'
  get '/about-us',      to: 'pages#about_us'
  get '/faq',           to: 'pages#faq'
  get '/how-it-works',  to: 'pages#how_it_works'
  get '/home_page/edit', to: 'pages#edit'
  post '/home_page/update', to: 'pages#update'

  resources :home_pages, controller: 'pages', only: [] do
    resources :images, only: [:new, :create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resources :user_courses, only: [:edit, :update]
  end
  resource :account do
    collection do
      post :add_image
      delete :remove_image
    end
  end

  resources :invites, only: [:create]

  resources :questions do
    resources :answers
  end

  resources :answers

  resources :courses, except: [:index, :index_enrolled] do
    get 'enrolled' => 'courses#index_enrolled', on: :collection

    scope(path_names: { admin_index: 'admin', answer: 'answer' }) do
      resources :office_hours, path: 'office-hours' do
        collection do
          get :admin_index
        end
        member do
          get :answer
        end
      end

    end

    resources :questions

    resources :messages, only: [:create]
    resources :chapters, except: [:index] do
      get 'watch', on: :member
      put 'move',  on: :member
    end
    resources :reviews, controller: 'course_reviews', except: [:show]
    resources :comments, controller: 'course_comments', only: [:create, :update] do
      resource :image, parent: 'comment'
    end
    resources :facts, controller: 'course_facts', except: [:index, :show] do
      resource :image, parent: 'fact'
    end

    resources :topics, controller: 'course_comments', only: [:new, :show, :edit, :update]

    # admin only
    resources :coupons, except: [:show]
    resources :email_templates, except: [:show]
    resources :images, only: [:new, :create, :destroy]
    resources :documents, only: [:new, :create, :edit, :update, :destroy] do
      get 'download', on: :member
    end
    resources :user_courses, only: [:index] do
      get 'prospects', on: :collection
    end

    member do
      # this must be a GET in order to handle redirect after OAuth
      # get 'signup' => 'orders#new'
      get 'enrolled' => 'courses#show_enrolled'
    end

    collection do
      resources :reviews, controller: 'course_reviews', only: [:index]
    end
  end

  get       '/cart' => 'carts#show', as: 'user_cart'
  # this must be a GET in order to handle redirect after OAuth
  get       '/cart/add_product/:product_id' => 'carts#add_product', as: 'add_product'
  delete    '/cart/remove_product/:product_id' => 'carts#remove_product', as: 'remove_product'
  post      '/cart/add_coupon' => 'carts#add_coupon', as: 'add_coupon'

  resources :carts, only: [:index, :show, :update, :destroy]
  resources :orders, except: [:new, :edit, :update] do
    resources :payments, only: [:edit] do
      put 'refund', on: :member
    end
  end
  resources :payments, only: [:edit, :update]
  resources :products do
    resources :recommendations, except: [:show, :index]
  end

  resources :instructors do
    resources :images, only: [:new, :create, :destroy]
  end

  resources :students

  resources :notifications

  get  '/sign_in'  => 'user_sessions#new',     as: :sign_in
  get  '/sign_up'  => 'user_sessions#sign_up', as: :sign_up
  get  '/sign_out' => 'user_sessions#destroy', as: :sign_out

  match '/auth/:provider/callback' => 'user_sessions#create', via: [:get, :post]
  get  '/auth/failure' => 'user_sessions#failure'

  namespace :api, constraints: { format: /(json|js)/ } do
    namespace :v1 do
      resources :answers, only: [:create, :update, :show]
      resources :questions, only: [:index, :create, :update, :show]
      resources :course_comments, only: [:index, :create, :update, :show]
      resources :course_reviews, only: [:create, :update, :show]
      resources :courses, only: [] do
        resources :uploads, only: [:create, :destroy, :update]
        collection do
          get :upcoming
        end
      end
      resource :user, only: [] do
        resources :courses, only: :index do
          collection do
            get :recommended
          end
        end
      end
      resources :users, only: [] do
        resources :user_courses, only: [:update]
        resource :cart, only: [:show, :update] do
          member do
            put :add_coupon
          end
        end
      end
    end
  end
end
