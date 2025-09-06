class RegistrationsController < Devise::RegistrationsController
 
	def sign_up(_resource_name, user)
    super
    uu=params[:user]
    #print "Registrations callback " + user.inspect + " Resource " + uu.inspect
    user.name = uu[:name]
    user.create_or_update_people()
  end
end