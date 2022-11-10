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
    self.table_name = "article_users"
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

      subscribe_and_link_to_stream(
        -> (event) { assign_user(event, event.data.fetch(:user_id)) },
        [Crm::UserAssignedToArticle]
      )

      subscribe_and_link_to_stream(
        -> (event) { create_user(event) },
        [Crm::UserRegistered]
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

    def broadcast_article_state_change(article_id, new_state)
      Turbo::StreamsChannel.broadcast_update_later_to(
        "articles_article_#{article_id}",
        target: "articles_article_#{article_id}_state",
        html: new_state)
    end

    def assign_user(event, user_id)
      create_draft_article(event.data.fetch(:article_id))
      with_article(event) { |article| article.author = User.find_by_uid(user_id).name }
    end

    def create_draft_article(uid)
      return if Article.where(uid: uid).exists?
      Article.create!(uid: uid, state: "Draft")
    end

    def with_article(event)
      Article
        .find_by_uid(event.data.fetch(:article_id))
        .tap do |article|
          yield(article)
          article.save!
        end
    end

    def create_user(event)
      User.create(
        uid:  event.data.fetch(:user_id),
        name: event.data.fetch(:name)
      )
    end

  end
end