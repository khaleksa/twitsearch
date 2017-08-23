Rails.application.routes.draw do
  root to: 'dashboards#show'

  resource  :dashboard, only: [] do
    get :search
  end
end
