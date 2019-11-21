module RidesHelper
  def dollars(amount)
    if amount.nil?
      ""
    else
      "$#{amount}"
    end
  end
end
