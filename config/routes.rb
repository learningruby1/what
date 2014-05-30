Rails.application.routes.draw do

  root 'welcome#index'

  resources :templates, :only => [:index] do
    resources :documents, :only => [:new, :create]
  end

  resources :documents, :only => [:index, :destroy] do
    resources :document_answers, :only => [:new, :create], :as => :answers
    get 'step/:step/edit' => 'document_answers#edit', :as => :answer
    post 'step/:step' => 'document_answers#update', :as => :answer_update
  end

end