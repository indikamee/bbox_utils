class RoleInfo 
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    include ActiveModel::Model

    attr_accessor :person_id, :resource_type, :resource_id, :role_name

    @person_id
    @resource_type
    @resource_id
    @role_name

end