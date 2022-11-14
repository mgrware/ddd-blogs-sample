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

  class OnLikeArticle
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Article, command.aggregate_id) do |article|
        article.like(command.user_id)
      end
    end
  end

  class OnReadArticle
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Article, command.aggregate_id) do |article|
        article.read(command.user_id)
      end
    end
  end

  class OnCommentArticle
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Article, command.aggregate_id) do |article|
        article.comment(command.user_id, command.content)
      end
    end
  end
end
