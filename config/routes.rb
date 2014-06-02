Rails.application.routes.draw do

  devise_for :users
  root 'welcome#index'

  resources :templates, :only => [:index] do
    resources :documents, :only => [:new, :create]
  end

  resources :documents, :only => [] do
    resources :document_answers, :only => [:new, :create], :as => :answers
    get 'step/:step/edit' => 'document_answers#edit', :as => :answer
    post 'step/:step' => 'document_answers#update', :as => :answer_update
  end

end