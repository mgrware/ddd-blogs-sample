module Crm
  class UserRegistered < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :name,       Infra::Types::String
  end
end


