class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :access, :rails_admin
      can :dashboard
      can :manage, :all
    end

    if user.subscriptions.blank?
      can :pro, Subscription
      can :pro_confirm, Subscription
    end

    if user.subscriptions.present?
      sub = user.subscriptions.take
      can :card, Subscription
      can :card_update, Subscription
      if sub.status == "active"
        can :cancel, Subscription
        can :cancel_confirm, Subscription
      elsif sub.status == "canceled" && sub.end_date > Time.now
        can :resume, Subscription
        can :resume_confirm, Subscription
      elsif sub.status == "canceled" && sub.end_date < Time.now
        can :pro, Subscription
        can :pro_confirm, Subscription
        cannot :card, Subscription
        cannot :card_update, Subscription
      elsif sub.status == "past_due"
        can :cancel, Subscription
        can :cancel_confirm, Subscription
      end
    end
  end
end