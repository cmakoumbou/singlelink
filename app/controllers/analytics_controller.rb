class AnalyticsController < ApplicationController
  before_action :authenticate_user!
  before_action :subscribed_user, only: [:index, :year]
  before_action :non_subscribed, only: [:showcase]

  def index
  	# User
  	@user = current_user

  	# Data
  	@profile_events = Ahoy::Event.where.not(user_id: @user.id).where(properties: [visited_user: @user.id])
  	@profile_visits = @profile_events.where(name: "Profile visit")

    # Data for one month
    @from = Time.now.in_time_zone(@user.time_zone).beginning_of_month
    @to = Time.now.in_time_zone(@user.time_zone).end_of_month
  	@profile_visits_month = @profile_visits.where(time: @from..@to)

  	# Profile
  	@profile_visits_count = @profile_visits_month.count
  	@profile_visits_unique_count = @profile_visits_month.uniq.pluck(:visit_id).count
    @from_profile = Time.now.beginning_of_month
    @to_profile = Time.now.end_of_month
  	@profile_visits_chart = @profile_visits.group_by_day(:time, time_zone: @user.time_zone, format: "%B %d, %Y",
                           range: @from_profile..@to_profile).count

  	# Device
  	@profile_visits_device_chart = @profile_visits_month.select(:visit_id).uniq.joins(:visit).group("device_type").count

  	# City
  	@profile_visits_city = @profile_visits_month.select(:visit_id).uniq.joins(:visit).group("city").count
  	@profile_visits_city_chart = @profile_visits_city.except(nil)

  	# Country
  	@profile_visits_country_chart = @profile_visits_month.select(:visit_id).uniq.joins(:visit).group("country").count
  end

  def year
    # User
    @user = current_user

    # Data
    @profile_events = Ahoy::Event.where.not(user_id: @user.id).where(properties: [visited_user: @user.id])
    @profile_visits = @profile_events.where(name: "Profile visit")

    # Data for one month
    @from = Time.now.in_time_zone(@user.time_zone).beginning_of_year
    @to = Time.now.in_time_zone(@user.time_zone).end_of_year
    @profile_visits_year = @profile_visits.where(time: @from..@to)

    # Profile
    @profile_visits_count = @profile_visits_year.count
    @profile_visits_unique_count = @profile_visits_year.uniq.pluck(:visit_id).count
    @from_profile = Time.now.beginning_of_year
    @to_profile = Time.now.end_of_year
    @profile_visits_chart = @profile_visits.group_by_day(:time, time_zone: @user.time_zone, format: "%B %d, %Y",
                           range: @from_profile..@to_profile).count

    # Device
    @profile_visits_device_chart = @profile_visits_year.select(:visit_id).uniq.joins(:visit).group("device_type").count

    # City
    @profile_visits_city = @profile_visits_year.select(:visit_id).uniq.joins(:visit).group("city").count
    @profile_visits_city_chart = @profile_visits_city.except(nil)

    # Country
    @profile_visits_country_chart = @profile_visits_year.select(:visit_id).uniq.joins(:visit).group("country").count
  end

  def showcase
  end

  private
    def subscribed_user
      redirect_to analytics_showcase_url unless user_subscribed?
    end

    def non_subscribed
      redirect_to analytics_url unless !user_subscribed?
    end
end

