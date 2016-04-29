class CardsController < ApplicationController
  before_action :authenticate_user!, except: [:profile]
  before_action :correct_card, only: [:edit, :update, :destroy, :move_up, :move_down, :enable, :disable]
  before_action :set_device_type, only: [:profile]
  # layout :resolve_layout

  def index
    authorize! :index, Card, :message => "Enter your payment details to gain access to your homepage."
    @cards = current_user.cards.order(position: :asc)
  end

  def profile
    @user = User.friendly.find(params[:id])
    @cards = @user.cards.order(position: :asc)
  end

  def new
    authorize! :new, Card
    @card = Card.new
  end

  def create
    authorize! :create, Card
    @card = current_user.cards.build(card_params)

    if @card.save
      redirect_to cards_url, notice: 'Card was successfully created.'
    else
      render :new
    end
  end

  def edit
    authorize! :edit, Card
  end

  def update
    authorize! :update, Card
    if @card.update(card_params)
      redirect_to cards_url, notice: 'Card was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize! :destroy, Card
    @card.destroy
    redirect_to cards_url, notice: 'Card was successfully destroyed.'
  end

  def move_up
    authorize! :move_up, Card
    @card.move_higher
    redirect_to cards_url, notice: 'Card was successfully moved up.'
  end

  def move_down
    authorize! :move_down, Card
    @card.move_lower
    redirect_to cards_url, notice: 'Card was successfully moved down.'
  end

  def enable
    authorize! :enable, Card
    @card.disable = false
    @card.save
    redirect_to cards_url, notice: 'Card was successfully enabled.'
  end

  def disable
    authorize! :disable, Card
    @card.disable = true
    @card.save
    redirect_to cards_url, notice: 'Card was successfully disabled.'
  end

  private

  def correct_card
    @card = Card.find(params[:id])
    redirect_to cards_url, alert: 'Unauthorized access' unless @card.user == current_user
  end

  def card_params
    params.require(:card).permit(:url, :title, :image, :remove_image, :default_image)
  end

  def resolve_layout
    case action_name
    when "profile"
      "showcase"
    else
      "application"
    end
  end

  def set_device_type
    request.variant = :phone if browser.device.mobile?
    request.variant = :tablet if browser.device.tablet?
  end
end
