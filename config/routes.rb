Rails.application.routes.draw do

  options = Rails.env.production? ? { path: "", constraints: { subdomain: 'es' }} : {}

  concern :pick do
    member do
      get :pick
      patch :pick, action: :update_pick
    end
  end

  concern :review do
    member do
      get :review
      patch :review, action: :update_review
    end
  end

  namespace :merchants, options do
    resource :merchant_session, path: "session"
    resource :merchant do
      get :forget_password
      match :verification_code, via: [:get, :post, :patch]
      match :confirm, via: [:post, :patch]

      get :password
      patch :password, action: :update_password
    end

    resource :note

    resources :orders, concerns: [:pick, :review] do
      resources :bids do
        member do
          get :pick
        end
      end

      resources :numbers

      collection do
        get :"pay/:id", action: :pay, as: :pay
      end

      member do
        post :pend
        post :cancel
        match :refund, via: [:get, :patch]
        match :notify, via: [:get, :post]
        get :result
        post :confirm
        post :rework
        get :revoke
        get :remark
        patch :remark, action: :update_remark
      end
    end

    namespace :hosting do
      resources :orders, concerns: [:pick, :review] do
        resources :partchecks
        member do
          match :refund, via: [:get, :patch]
          post :confirm
          post :rework
          get :revoke
          get :remark
          patch :remark, action: :update_remark
          get :procedure_price
          patch :procedure_price, action: :update_procedure_price
          get :emergency
          get :unemergency
          post :confirmwithdrawal
          get :service_staff
        end
        collection do
          get 'automatic'
          get 'automatic_pop'
        end
      end
      resources :numbers
      resources :partchecks
    end

    resources :merchants
    resources :mechanics do
      member do
        post :follow
        post :unfollow
        get :remark
        patch :remark, action: :update_remark
        get :reviews
        get :"skills/:skill", action: :skill, as: :skill
      end
    end

    namespace :admin do
      resources :merchants do
        member do
          post :active
          post :inactive
        end
      end
      resources :orders do
        member do
          post :close
        end
      end
      resource :store
      resources :recharges do
        member do
          match :notify, via: [:get, :post]
          get :result
        end
      end
    end

    namespace :store do
      resources :orders
    end
    resource :store

    root to: "orders#new"
  end

  mount WeixinRailsMiddleware::Engine, at: "/"
  resource :user do
      member do
        get :photo
        patch :update_photo
        get :holiday
        patch :update_holiday
      end
    end
  resource :user_session, path: "session" do
    post :verification_code
  end
  resource :user_group do
    get :weixin_qr_code
    get :users
  end
  resources :mechanics do
    member do
      get :follow
      get :unfollow
      get :reviews
    end
  end

  resources :orders, concerns: [:review] do
    resources :bids do
      member do
        get :pick
      end
    end

    collection do
      get :"pay/:id", action: :pay, as: :pay
      get :not_found
    end

    member do
      get :cancel
      get :refund
      post :notify
      get :result
      get :work
      patch :finish
      get :confirm
    end
  end

  resources :withdrawals

  namespace :admin do
    concern :confirm do
      collection do
        get :confirmed
      end
      member do
        post :confirm
      end
    end
    concern :confirm_nopay do
      collection do
        get :confirm_nopayed
      end
      member do
        post :confirm_nopay
      end
    end
    concern :message do
      member do
        post :message
      end
    end
    concern :cancel do
      collection do
        get :canceled
      end
      member do
        post :cancel
      end
    end
    concern :hide do
      collection do
        get :hidden
      end
      member do
        post :hide
        post :unhide
      end
    end
    concern :freeze do
      collection do
        get :frozen
      end
      member do
        post :freeze
      end
    end
    concern :hidereg do
      collection do
        get :reg
      end
      member do
        post :hidereg
      end
    end
    concern :hideupdate do
      collection do
        get :userupdate
      end
      member do
        post :hideupdate
      end
    end

    resource :administrator_session, path: "session"
    resource :administrator, only: [] do
      get :forget_password
      match :verification_code, via: [:get, :post, :patch]
      match :confirm, via: [:post, :patch]

      get :password
      patch :password, action: :update_password
    end

    resources :administrators do
      member do
        post :active
        post :inactive
      end
    end

    resources :users do
      member do
        post :mechanicize

        get :balance,:clear_weixin,:clear_withdrawal_weixin
        patch :balance, action: :update_balance
      end
    end
    resources :user_groups, concerns: [:confirm]
    resources :mechanics, concerns: [:hide,:hidereg,:hideupdate] do
      resources :orders
      resources :metrics
      collection do
        get :import
        post :import, action: :create_import
      end

      member do
        post :clientize
      end
    end
    resources :merchants, concerns: [:confirm] do
      resources :orders
      resources :metrics
      member do
        post :active
        post :inactive
        get :settings
        post :settings, action: :update_settings
        get :product
        patch :product, action: :update_product
      end
    end
    resources :orders
    resources :metrics
    resources :refunds, concerns: [:confirm, :freeze]
    resources :withdrawals, concerns: [:confirm, :cancel, :confirm_nopay, :message] do
      collection do
        get :settings
        post :settings, action: :update_settings
      end
    end
    namespace :settings do
      resources :skills
      resources :brands
      resources :series, except: :show
    end
    namespace :reports do
      resources :provinces
      resources :finishedprovinces
      resources :dayreports
      resources :profits
      resources :partchecks
    end

    root to: "users#index"
  end

  root to: "users#show"
end
