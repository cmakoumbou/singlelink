class LinksController < ApplicationController
  before_action :authenticate_user!, except: [:profile]
  before_action :correct_link, only: [:edit, :update]

  def index
    @links = current_user.links
  end

  def profile
    @user = User.friendly.find(params[:id])
    @links = @user.links
  end

  def new
    @link = Link.new
  end

  def edit
  end

  def create
    @link = current_user.links.build(link_params)

    if @link.save
      redirect_to links_url, notice: 'Link was successfully created.'
    else
      render :new
    end
  end

  def update
    if @link.update(link_params)
      redirect_to links_url, notice: 'Link was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @link = current_user.links.find(params[:id])
    @link.destroy
    redirect_to links_url, notice: 'Link was successfully destroyed.'
  end

  private
    def correct_link
      @link = Link.find(params[:id])
      redirect_to links_url unless @link.user == current_user
    end

    def link_params
      params.require(:link).permit(:url)
    end
end
