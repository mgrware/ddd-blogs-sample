
module Blogging
  class ArticleSubmitted < Infra::Event
    attribute :article_number, Infra::Types::ArticleNumber
    attribute :content, Infra::Types::String
    attribute :title, Infra::Types::String
  end
end
