module Blogging
  class ArticleLiked < Infra::Event
    attribute :article_id, Infra::Types::UUID
    attribute :user_id, Infra::Types::UUID
  end
end
