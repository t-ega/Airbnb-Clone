class FetchCryptoPrice < ApplicationService
  include QuidaxInitializer

  def initialize(market)
    @market = market
  end

  def call
    begin
      ticker =
        QuidaxMarkets.get_ticker(
          q_object: self.class.quidax_object,
          market: @market
        )
    rescue QuidaxServerError => e
      Rails.logger.error(e)
      return
    end

    result = ticker.with_indifferent_access
    data = result[:data]
    data.dig(:ticker, :low)
  end
end
