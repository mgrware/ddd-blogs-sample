module Crm
  class OnSetUser
    
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
      @event_store = event_store
    end

    def call(command)
      raise User::NotExists unless user_exists?(command.user_id)
      @repository.with_aggregate(Article, command.aggregate_id) do |article|
        article.set_user(command.user_id)
      end
    end

    private

    def user_exists?(user_id)
      user_stream = @repository.stream_name(User, user_id)
      !@event_store.read.stream(user_stream).count.eql?(0)
    end
  end
end