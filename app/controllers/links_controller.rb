class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:profile]
  before_action :correct_link, only: [:edit, :update, :destroy, :move_up, :move_down, :enable, :disable]

  def index
    authorize! :index, Link
    @links = current_user.links.order(position: :asc)
  end

  def profile
    @user = User.friendly.find(params[:id])
    @links = @user.links.order(position: :asc)
  end

  def new
    authorize! :new, Link
    @link = Link.new
  end

  def create
    authorize! :create, Link
    @link = current_user.links.build(link_params)

    if @link.save
      redirect_to links_url, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize! :edit, Link
  end

  def update
    authorize! :update, Link
    if @link.update(link_params)
      redirect_to links_url, notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, Link
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  def move_up
    authorize! :move_up, Link
    @link.move_higher
    redirect_to links_url, notice: 'Link was successfully moved up.'
  end

  def move_down
    authorize! :move_down, Link
    @link.move_lower
    redirect_to links_url, notice: 'Link was successfully moved down.'
  end

  def enable
    authorize! :enable, Link
    @link.disable = false
    @link.save
    redirect_to links_url, notice: 'Link was successfully enabled.'
  end

  def disable
    authorize! :disable, Link
    @link.disable = true
    @link.save
    redirect_to links_url, notice: 'Link was successfully disabled.'
  end

  private
    def correct_link
      @link = Link.find(params[:id])
      redirect_to links_url, alert: 'Unauthorized access' unless @link.user == current_user
    end

    def link_params
      params.require(:link).permit(:url, :title, :image, :remove_image, :default_image)
    end

    # def track_visit
    #   ahoy.track_visit
    # end
end
