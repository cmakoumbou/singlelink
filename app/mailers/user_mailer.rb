class UserMailer < ApplicationMailer
	default from: 'notifications@example.com'

	def failed_payment(user, next_payment_attempt, attempt_count)
		@attempt_count = attempt_count
		@next_payment_attempt = next_payment_attempt
		@user = user
		mail(to: @user.email, subject: 'Failed payment')
	end
end