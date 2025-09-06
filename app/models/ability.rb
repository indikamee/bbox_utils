class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    return if user.blank? || user.person.nil?
  
    #can :manage, :all

    p = user.person
    if p.has_role? :admin
      can :manage, :all
    end
    
    can :manage, Event, id: Event.with_role(:admin, p).pluck(:id)
    can :bulk_edit, Event, id: Event.with_role([:admin,:agent], p).pluck(:id)
    can :manage, Ticket, event_id: Event.with_role(:admin, p).pluck(:id)
    can :manage, Ticket, agent_id: [nil, p.id], event: Event.with_role(:agent, p).pluck(:id)
    can :read, [:event, :ticket, :person]
   
    can :read, Event
    can :read, Ticket
    can :manage, p
    can :manage, User, id: user&.id
  end
end
