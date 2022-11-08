module Blogging
  class Article
    include AggregateRoot

    AlreadySubmitted = Class.new(StandardError)
    NotSubmitted = Class.new(StandardError)

    def initialize(id)
      @id = id
      @state = :draft
      @Page = Page.new
    end

    def submit(article_number, content, title)
      raise AlreadySubmitted if @state.equal?(:submitted)
      apply ArticleSubmitted.new(
        data: {
          article_id: @id,
          article_number: article_number,
          content: content,
          title: title
        }
      )
    end

    on ArticleSubmitted do |event|
      @user_id = event.data[:user_id]
      @article_number = event.data[:article_number]
      @state = :submitted
      @content = event.data[:content]
      @title = event.data[:title]
    end

  
    class Page
      def initialize
        @article_visitors = Hash.new(0)
      end

      def article_visitors
        @article_visitors
      end
    end
  end
end
