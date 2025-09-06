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

  private 
  def role_params
    params.require(:role_info).permit(:person_id, :resource_type, :resource_id, :role_name)
  end
end
