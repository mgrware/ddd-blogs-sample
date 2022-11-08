module Articles
  class Article < ApplicationRecord
    self.table_name = 'articles'

    has_many :article_visitors,
      -> { article(id: :asc) },
      class_name: "Articles::ArticleVisitor",
      foreign_key: :article_uid,
      primary_key: :uid
  end

  class User < ApplicationRecord
    self.table_name = "users"
  end

  class Author < ApplicationRecord
    self.table_name = "authors"
  end

  class ArticleVisitor < ApplicationRecord
    self.table_name = "article_visitors"
    
    def value
      10
    end
  end

  class Configuration
    def call(cqrs)
      @cqrs = cqrs
      subscribe_and_link_to_stream(
        ->(event) { mark_as_submitted(event) },
        [Blogging::ArticleSubmitted]
      )

      subscribe(
        ->(event) { broadcast_article_state_change(event.data.fetch(:article_id), 'Submitted') },
        [Blogging::ArticleSubmitted]
      )
    end

    private

    def subscribe_and_link_to_stream(handler, events)
      link_and_handle = ->(event) do
        link_to_stream(event)
        handler.call(event)
      end
      subscribe(link_and_handle, events)
    end

    def subscribe(handler, events)
      @cqrs.subscribe(handler, events)
    end

    def link_to_stream(event)
      @cqrs.link_event_to_stream(event, "Articles$all")
    end


    def mark_as_submitted(event)
      article = Article.find_or_create_by(uid: event.data.fetch(:article_id))
      article.article_number = event.data.fetch(:article_number)
      article.content = event.data.fetch(:content)
      article.title = event.data.fetch(:title)
      article.state = "Submitted"
      article.save!
    end

    def broadcast_article_state_change(order_id, new_state)
      Turbo::StreamsChannel.broadcast_update_later_to(
        "articles_article_#{order_id}",
        target: "articles_article_#{order_id}_state",
        html: new_state)
    end

  end
end