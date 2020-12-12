Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'commits', to: 'commits#index', constraints: { format: 'json' }
end
