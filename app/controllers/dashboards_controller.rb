class DashboardsController < ApplicationController
  def show
    @trends = TwitterProvider.trends
    @result = TwitterProvider.search(params[:q]) if params[:q].present?
  end
end