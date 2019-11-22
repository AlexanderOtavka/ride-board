module RidesHelper
  def dollars(amount)
    if amount.nil?
      ""
    else
      "$#{amount}"
    end
  end

  def seats_remaining(ride)
    total = ride.seats
    taken = ride.passengers.count
    if total.nil?
      "Unlimited (#{taken} taken)"
    else
      remaining = total - taken
      "#{remaining}/#{total}"
    end
  end
end
