module Crm
  class RegisterUser < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :name, Infra::Types::String
    alias aggregate_id user_id
  end
end
