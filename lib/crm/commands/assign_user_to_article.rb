module Crm
  class AssignUserToArticle < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :article_id, Infra::Types::UUID
    alias aggregate_id article_id
  end
end
