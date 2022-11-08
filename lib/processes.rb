require_relative "blogging"

module Processes
  class Configuration
    def call(cqrs)
      enable_release_payment_process(cqrs)
    end

    private

    def enable_release_payment_process(cqrs)
      # cqrs.subscribe(
      #   ReleasePaymentProcess.new(cqrs),
      #   [
      #     Ordering::OrderSubmitted,
      #     Ordering::OrderExpired,
      #     Ordering::OrderConfirmed,
      #     Payments::PaymentAuthorized,
      #     Payments::PaymentReleased
      #   ]
      # )
    end
  end
end
