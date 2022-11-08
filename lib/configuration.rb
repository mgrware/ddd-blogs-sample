require_relative "handlers"

class Configuration
  def call(cqrs)
    enable_res_infra_event_linking(cqrs)

    enable_articles_read_model(cqrs)

    Handlers::Configuration.new(
      number_generator: Rails.configuration.number_generator
     ).call(cqrs)
  end

  private

  def enable_res_infra_event_linking(cqrs)
    [
      RailsEventStore::LinkByEventType.new,
      RailsEventStore::LinkByCorrelationId.new,
      RailsEventStore::LinkByCausationId.new
    ].each { |h| cqrs.subscribe_to_all_events(h) }
  end

  def enable_articles_read_model(cqrs)
    Articles::Configuration.new.call(cqrs)
  end
end
