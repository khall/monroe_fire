module RunHelper
  def pretty_time(minutes)
    "#{(minutes / 60).floor}:#{"%02d" % (minutes % 60)}"
  end
end