Rails.application.routes.draw do
  root to: 'dashboards#show'

  resource  :dashboard, only: [] do
    post :set_location
  end
end
