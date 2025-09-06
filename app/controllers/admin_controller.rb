class AdminController < ApplicationController
  authorize_resource :class => false

  def list_roles
    @role_info = RoleInfo.new
    @resource_types = [Event.name]
  end


  def create_role
    p = Person.find(role_params[:person_id])
    resource_type = role_params[:resource_type]
    resource_id = role_params[:resource_id]
    role_name = role_params[:role_name]

    # Step 1: Get the model class from the resource_type parameter
    if resource_type.present?
      model_class = resource_type.constantize 
      # Step 2: Find the object using the model_class and resource_id
      if resource_id.present?
        resource_object = model_class.find_by(id: resource_id)
        p.add_role(role_name, resource_object)
      else
        p.add_role(role_name, model_class)
      end
    else
      p.add_role(role_name)
    end
    redirect_to admin_list_roles_path, notice: "Role added successfully"
  end

  def remove_role
    p = Person.find(role_params[:person_id])
    resource_type = role_params[:resource_type]
    resource_id = role_params[:resource_id]
    role_name = role_params[:role_name]

    # Step 1: Get the model class from the resource_type parameter
    if resource_type.present?
      model_class = resource_type.constantize 
      # Step 2: Find the object using the model_class and resource_id
      if resource_id.present?
        resource_object = model_class.find_by(id: resource_id)
        p.remove_role(role_name, resource_object)
      else
        p.remove_role(role_name, model_class)
      end
    else
      p.remove_role(role_name)
    end
    redirect_to admin_list_roles_path, notice: "Role removed successfully"
  end

  def list_items
  end


  def new_user
   @user = User.new
  end

  def create_user
    @user = User.new(user_params)
    @user.confirmed_at = Time.now
    if !@user.password.eql?(@user.password_confirmation)
      respond_to do |format|
        flash[:error] = "password doesn't match"
        format.html { render :new_user }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
      return
    end
    if @user.save(validate: true)
        flash[:notice] = 'User was successfully created.'
        respond_to do |format|
          format.html { redirect_to @user }
          format.json { render :show, status: :created, location: @user }
        end
    else
        respond_to do |format|
            format.html { render :new_user }
            format.json { render json: @user.errors, status: :unprocessable_entity }
        end
    end
  end

  private 
  def role_params
    params.require(:role_info).permit(:person_id, :resource_type, :resource_id, :role_name)
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end
end
