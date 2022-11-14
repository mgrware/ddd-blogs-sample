module Blogging
  class ReadArticle < Infra::Command
    attribute :article_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID

    alias aggregate_id article_id
  end
end
