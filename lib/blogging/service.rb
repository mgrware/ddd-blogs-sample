module Blogging
  class OnSubmitArticle
    def initialize(event_store, number_generator)
      @repository = Infra::AggregateRootRepository.new(event_store)
      @number_generator = number_generator
    end

    def call(command)
      @repository.with_aggregate(Article, command.aggregate_id) do |article|
        article_number = @number_generator.call
        article.submit(article_number, command.content, command.title)
      end
    end
  end
end
