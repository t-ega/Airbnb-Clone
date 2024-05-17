module ReservationsHelper
  def format_estimated_price
    @estimated_price.round(5)
  end

  def build_qr_code
    RQRCode::QRCode.new(@wallet_address).as_png
  end

  def format_checkin_date
    @checkin_date.strftime("%B %e, %Y")
  end

  def format_checkout_date
    @checkout_date.strftime("%B %e, %Y")
  end

  def format_currency
    @currency.upcase
  end
end
