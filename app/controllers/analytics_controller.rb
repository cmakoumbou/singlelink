class AnalyticsController < ApplicationController
  def index

  	# User
  	@user = current_user

  	# Data
  	@profile_events = Ahoy::Event.where(properties: [visited_user: current_user.id])
  	@profile_visits = @profile_events.where(name: "Profile visit")
  	@profile_visits_month = @profile_visits.where(time: 1.month.ago.midnight..Time.now)

  	# Profile
  	@profile_visits_count = @profile_visits.count
  	@profile_visits_unique_count = @profile_visits.uniq.pluck(:visit_id).count
  	@profile_visits_chart = @profile_visits.group_by_day(:time, range: 1.month.ago.midnight..Time.now).count

  	# Device
  	@profile_visits_device_chart = @profile_visits_month.select(:visit_id).uniq.joins(:visit).group("device_type").count

  	# City
  	@profile_visits_city = @profile_visits_month.select(:visit_id).uniq.joins(:visit).group("city").count
  	@profile_visits_city_chart = @profile_visits_city.except(nil)

  	# Country
  	@profile_visits_country_chart = @profile_visits_month.select(:visit_id).uniq.joins(:visit).group("country").count
  end
end

