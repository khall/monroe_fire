module RunHelper
  def pretty_time(minutes, options = {})
    minutes *= 60 if options[:hours]
    if options[:pad]
      "#{"%02d" % ((minutes / 60).floor)}:#{"%02d" % (minutes % 60)}"
    else
      "#{(minutes / 60).floor}:#{"%02d" % (minutes % 60)}"
    end
  end
end