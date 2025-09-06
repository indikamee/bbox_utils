class User < ApplicationRecord
  has_one :person
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, :confirmable, omniauth_providers: [:google_oauth2]

  def self.from_omniauth(auth)  
      #print "AUTH RESPONSE " + auth.inspect
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0,20]
      if ['google', 'google_oauth2'].include?(auth.provider)
        #print "Skip confirmation " + auth.inspect
        user.confirmed_at = Time.zone.now
        user.skip_confirmation!
      end
    end
  end

  # def populate_agent_roles
  #   if Agent.where(email: email).any? and !has_role?(:agent) 
  #     add_role(:agent)
  #   end
  # end

end
