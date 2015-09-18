class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:profile]
  before_action :correct_link, only: [:edit, :update, :destroy, :move_up, :move_down]

  def index
    @links = current_user.links.order(:row_order)
  end

  def profile
    @user = User.friendly.find(params[:id])
    @links = @user.links.order(:row_order)
    ahoy.track("Profile visit", user_id: @user.id)
  end

  def new
    @link = Link.new
  end

  def create
    @link = current_user.links.build(link_params)

    if @link.save
      redirect_to links_url, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @link.update(link_params)
      redirect_to links_url, notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  def move_up
    @link.update_attribute :row_order_position, :up
    redirect_to links_url
  end

  def move_down
    @link.update_attribute :row_order_position, :down
    redirect_to links_url
  end

  private
    def correct_link
      @link = Link.find(params[:id])
      redirect_to links_url, alert: 'Unauthorized access' unless @link.user == current_user
    end

    def link_params
      params.require(:link).permit(:url)
    end
end
