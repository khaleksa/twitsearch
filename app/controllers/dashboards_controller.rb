class DashboardsController < ApplicationController
  def show
    @q = params[:q] || ''
    @trends = TwitterProvider.trends
  end

  def search
    @result = TwitterProvider.search(params[:q])
  end
end