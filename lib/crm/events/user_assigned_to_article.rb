module Crm
  class UserAssignedToArticle < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :article_id, Infra::Types::UUID
  end
end
