class DashboardsController < ApplicationController
  before_filter :get_country

  def show
    @trends = TwitterProvider.trends(@country_id)
    @countries = TwitterProvider.locations
    @result = TwitterProvider.search(params[:q]) if params[:q].present?
  end

  def set_location
    cookies.permanent[:woeid] = @country_id
    @trends = TwitterProvider.trends(@country_id)
  end

  private

  def get_country
    @country_id = [(params[:woeid].present? ? params[:woeid] : cookies[:woeid]).to_i, TwitterApi::Trends::DEFAULT_WOEID].max
    @country_name = @country_id == 1 ? '' : TwitterProvider.locations[@country_id].to_s
  end
end