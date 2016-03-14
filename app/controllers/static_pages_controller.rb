class StaticPagesController < ApplicationController

  def home
    @user = User.first
    @links = @user.links.order(position: :asc)
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
  
end
