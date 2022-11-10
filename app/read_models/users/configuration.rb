module Users
  class User < ApplicationRecord
    self.table_name = "users"
  end

  class Configuration

    def call(cqrs)
      cqrs.subscribe(
        -> (event) { register_user(event) },
        [Crm::UserRegistered]
      )
    end

    private

    def register_user(event)
      User.create(id: event.data.fetch(:user_id), name: event.data.fetch(:name))
    end

    def find(user_id)
      User.where(id: user_id).first
    end
  end
end
