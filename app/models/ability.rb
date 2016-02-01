class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    end

    if user.subscriptions.blank?
      can :index, Link
      can :index, Subscription
      can :pro_new, Subscription
    end

    if user.subscriptions.present?
      sub = user.subscriptions.take
      can :card, Subscription
      can :card_update, Subscription
      if sub.status == "active"
        can :manage, Link
        can :cancel, Subscription
        can :cancel_confirm, Subscription
      elsif sub.status == "canceled" && sub.end_date > Time.now
        can :manage, Link
        can :resume, Subscription
        can :resume_confirm, Subscription
      elsif sub.status == "canceled" && sub.end_date < Time.now
        can :index, Link
        can :renew, Subscription
        can :renew_confirm, Subscription
        cannot :card, Subscription
        cannot :card_confirm, Subscription
      elsif sub.status == "past_due"
        can :manage, Link
        can :cancel, Subscription
        can :cancel_confirm, Subscription
      end
    end
  end
end