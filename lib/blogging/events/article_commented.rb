module Blogging
  class ArticleCommented < Infra::Event
    attribute :article_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :user_id, Infra::Types::UUID
  end
end
