module Crm
  class Article
    include AggregateRoot
    UserAlreadyAssigned = Class.new(StandardError)

    def initialize(id)
      @id = id
    end

    def set_user(user_id)
      raise UserAlreadyAssigned if @user_id
      apply UserAssignedToArticle.new(data: { article_id: @id, user_id: user_id })
    end

    private

    on UserAssignedToArticle do |event|
      @user_id = event.data[:user_id]
    end
  end
end