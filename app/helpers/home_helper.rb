module HomeHelper
    def format_average_rating(rating)
        return 0 unless rating.present?
        rating.round(2)
    end
end
