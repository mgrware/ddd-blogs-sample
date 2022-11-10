module Crm
  class User
    include AggregateRoot

    AlreadyVip = Class.new(StandardError)
    AlreadyRegistered = Class.new(StandardError)
    NotExists = Class.new(StandardError)

    def initialize(id)
      @id = id
    end

    def register(name)
      raise AlreadyRegistered if @registered
      apply UserRegistered.new(
          data: {
              user_id: @id,
              name: name
          }
        )
    end

    on UserRegistered do |event|
      @registered = true
    end
  end
end
