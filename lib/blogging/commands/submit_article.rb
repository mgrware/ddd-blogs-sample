module Blogging
  class SubmitArticle < Infra::Command
    attribute :article_id, Infra::Types::UUID
    attribute :content, Infra::Types::String
    attribute :title, Infra::Types::String

    alias aggregate_id article_id
  end
end
