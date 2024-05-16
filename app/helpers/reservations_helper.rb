module ReservationsHelper
    def format_estimated_price
        @estimated_price.round(5)
    end
end
