class DashboardsController < ApplicationController
  def show
    @q = params[:q] || ''
    @trends = Api::Twitter.new.trends
  end

  def search
    @result = Api::Twitter.new.search(params[:q])
  end
end