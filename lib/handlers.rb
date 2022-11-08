require_relative "blogging"

module Handlers
  class Configuration
    def initialize(number_generator: nil)
      @number_generator = number_generator
    end

    def call(cqrs)
      configure_bounded_contexts(cqrs)
      # configure_processes(cqrs)
    end

    def configure_bounded_contexts(cqrs)
      raise ArgumentError.new(
        "Neither number_generator can be null"
      ) if @number_generator.nil? 
      [
        Blogging::Configuration.new(@number_generator)
      ].each { |c| c.call(cqrs) }
    end

    def configure_processes(cqrs)
      #Processes::Configuration.new.call(cqrs)
    end
  end
end
