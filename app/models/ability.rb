class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    end

    if user.subscriptions.blank?
      can :index, Subscription
      can :pro, Subscription
    end

    if user.subscriptions.present?
      sub = user.subscriptions.take
      can :card, Subscription
      if sub.status == "active"
        can :manage, Card
        can :cancel, Subscription
        cannot :new, Card if user.cards(:reload).count >= 30
        cannot :create, Card if user.cards(:reload).count >= 30
      elsif sub.status == "canceled" && sub.end_date > Time.now
        can :manage, Card
        can :resume, Subscription
        cannot :new, Card if user.cards(:reload).count >= 30
        cannot :create, Card if user.cards(:reload).count >= 30
      elsif sub.status == "canceled" && sub.end_date < Time.now
        can :index, Card
        can :renew, Subscription
        cannot :card, Subscription
      elsif sub.status == "past_due"
        can :manage, Card
        can :cancel, Subscription
        cannot :new, Card if user.cards(:reload).count >= 30
        cannot :create, Card if user.cards(:reload).count >= 30
      end
    end
  end
end