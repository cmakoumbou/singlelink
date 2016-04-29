class StaticPagesController < ApplicationController
  before_action :set_device_type, only: [:home]

  def home
  end
  
  def about
  end

  def help
  end

  def terms
  end

  def privacy
  end

  def contact
  end

  def features
  end

  def pricing
  end

  private

  def set_device_type
    request.variant = :phone if browser.device.mobile?
    request.variant = :tablet if browser.device.tablet?
  end
  
end
