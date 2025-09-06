class Event < ApplicationRecord
    has_many :tickets
    resourcify
    STATES = [:open, :forzen, :in_progress, :closed]
end
