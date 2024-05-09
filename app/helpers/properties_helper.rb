module PropertiesHelper
  def display_star_rating(rating)
    html_content = ""

    rating.times { html_content << <<~HTML }
          <svg xmlns="http://www.w3.org/2000/svg"
               viewBox="0 0 24 24"
               stroke-width="1.5"
               stroke="currentColor"
               class="w-3 h-3 fill-yellow-500">
              <path stroke-linecap="round" stroke-linejoin="round" d="M11.48 3.499a.562.562 0 0 1 1.04 0l2.125 5.111a.563.563 0 0 0 .475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 0 0-.182.557l1.285 5.385a.562.562 0 0 1-.84.61l-4.725-2.885a.562.562 0 0 0-.586 0L6.982 20.54a.562.562 0 0 1-.84-.61l1.285-5.386a.562.562 0 0 0-.182-.557l-4.204-3.602a.562.562 0 0 1 .321-.988l5.518-.442a.563.563 0 0 0 .475-.345L11.48 3.5Z" />
          </svg>
        HTML

    # For the remaining reviews
    (5 - rating).times { html_content << <<~HTML }
        <svg xmlns="http://www.w3.org/2000/svg"
             viewBox="0 0 24 24"
             fill="none"
             stroke-width="1.5"
             stroke="currentColor"
             class="w-3 h-3">
             <path stroke-linecap="round" stroke-linejoin="round" d="M11.48 3.499a.562.562 0 0 1 1.04 0l2.125 5.111a.563.563 0 0 0 .475.345l5.518.442c.499.04.701.663.321.988l-4.204 3.602a.563.563 0 0 0-.182.557l1.285 5.385a.562.562 0 0 1-.84.61l-4.725-2.885a.562.562 0 0 0-.586 0L6.982 20.54a.562.562 0 0 1-.84-.61l1.285-5.386a.562.562 0 0 0-.182-.557l-4.204-3.602a.562.562 0 0 1 .321-.988l5.518-.442a.563.563 0 0 0 .475-.345L11.48 3.5Z" />
        </svg>
      HTML
    html_content.html_safe
  end

  def calculate_property_total_price(price, nights = 1)
    price * nights
  end

  def call_to_action
    if @property.host == current_user
      return(
        link_to(
          "Edit",
          edit_property_path(@property),
          class:
            "h-10 border rounded-md w-full bg-red-700 text-white flex justify-center items-center"
        )
      )
    end

    button_tag(
      "Book Now",
      data: {
        submit_url: new_property_reservation_path(@property),
        action: "reservation-component#submitReservation"
      },
      type: "submit",
      class: "h-10 border rounded-md w-full bg-red-700 text-white"
    )
  end
end
