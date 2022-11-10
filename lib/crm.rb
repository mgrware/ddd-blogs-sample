require "infra"
require_relative "crm/commands/register_user"
require_relative "crm/commands/assign_user_to_article"
require_relative "crm/events/user_registered"
require_relative "crm/events/user_assigned_to_article"
require_relative "crm/user_service"
require_relative "crm/article_service"
require_relative "crm/article"
require_relative "crm/user"

module Crm
  class Configuration

    def call(cqrs)
      cqrs.register_command(RegisterUser, OnRegistration.new(cqrs.event_store))
      cqrs.register_command(AssignUserToArticle, OnSetUser.new(cqrs.event_store))
    end
  end
end
