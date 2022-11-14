module Blogging
  class CommentArticle < Infra::Command
    attribute :article_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
    attribute :content, Infra::Types::String

    alias aggregate_id article_id
  end
end
