module RidesHelper
  def now_cst_datetime
    DateTime.now.new_offset "-6:00"
  end
end
