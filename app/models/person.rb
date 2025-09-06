class Person < ApplicationRecord
    belongs_to :user, optional: true
    has_many :tickets

    rolify :before_add => :before_add_method

    def before_add_method(role)
    # do something before it gets added
    end
    def display_name
        s ="#{name}"
        (s = "#{s} [signed]") if user.present?
        (s = "#{s} - e:#{email}") if email.present?
    end
end
