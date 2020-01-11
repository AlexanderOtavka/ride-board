module RidesHelper
  def dollars(amount)
    if amount.nil?
      ""
    else
      number_to_currency(amount, unit: '$')
    end
  end

  def seats_text(ride)
    if ride.passengers.include? current_user
      others = ride.passengers.count - 1
      if others > 0
        pluralize(others, "other passenger")
      else
        "No other passengers"
      end
    else
      total = ride.seats
      taken = ride.passengers.count
      if total.nil?
        if taken > 0
          "#{pluralize(taken, "passenger")} already joined"
        else
          "No passengers have joined yet"
        end
      else
        remaining = total - taken
        if remaining > 0
          "#{pluralize(remaining, "seat")} available out of #{total} total"
        else
          "This ride is full"
        end
      end
    end
  end
end
