class AnalyticsController < ApplicationController
	def index
		@profile_events = Ahoy::Event.where(properties: [user_id: current_user.id])
		@profile_visits = @profile_events.where(name: "Profile visit")
		@profile_visits_total = @profile_visits.group_by_day(:time, range: 1.month.ago.midnight..Time.now).count
		@profile_visits_device = @profile_visits.joins(:visit).group("device_type").count
		@profile_visits_country = @profile_visits.joins(:visit).group("country").count
	end
end