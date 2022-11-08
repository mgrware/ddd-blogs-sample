require "infra"
require_relative "blogging/events/article_submitted"
require_relative "blogging/commands/submit_article"
require_relative "blogging/fake_number_generator"
require_relative "blogging/number_generator"
require_relative "blogging/service"
require_relative "blogging/article"


module Blogging
  class Configuration
    def initialize(number_generator)
      @number_generator = number_generator
    end

    def call(cqrs)
      cqrs.register_command(
        SubmitArticle,
        OnSubmitArticle.new(cqrs.event_store, @number_generator.call)
      )
    end
  end
end
