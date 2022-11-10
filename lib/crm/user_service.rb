module Crm
  class OnRegistration
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(User, command.aggregate_id) do |user|
        user.register(command.name)
      end
    end
  end
end