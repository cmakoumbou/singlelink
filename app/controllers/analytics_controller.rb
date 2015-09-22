class AnalyticsController < ApplicationController
  def index
  	@profile_events = Ahoy::Event.where(properties: [visited_user: current_user.id])
  	@profile_visits = @profile_events.where(name: "Profile visit")
  	@profile_visits_count = @profile_visits.count
  	@profile_visits_unique_count = @profile_visits.uniq.pluck(:visit_id).count
  	@profile_visits_device = @profile_visits.select(:visit_id).uniq.joins(:visit).group("device_type").count
  	@profile_visits_city = @profile_visits.select(:visit_id).uniq.joins(:visit).group("city").count
  	@profile_visits_country = @profile_visits.select(:visit_id).uniq.joins(:visit).group("country").count
  end
end
