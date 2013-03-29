module RunHelper
  def pretty_time(minutes, options = {})
    minutes *= 60 if options[:hours]
    if options[:pad]
      "#{"%02d" % ((minutes / 60).floor)}:#{"%02d" % (minutes % 60)}"
    else
      "#{(minutes / 60).floor}:#{"%02d" % (minutes % 60)}"
    end
  end

  def day_stats
    days_of_week = %w|Sunday Monday Tuesday Wednesday Thursday Friday Saturday|
    weekdays = @runs.map{|r| r.date.wday}
    sorted_popularity = weekdays.inject(Hash.new(0)) do |sum_arr, day|
      sum_arr[day] += 1
      sum_arr
    end

    sorted_popularity = fill_in_missing(sorted_popularity, 6)
    sorted_popularity = sorted_popularity.sort_by{|day| day[1]}
    most_popular_days = sorted_popularity.select{|day| day[1] == sorted_popularity.last[1]}.sort
    least_popular_days = sorted_popularity.select{|day| day[1] == sorted_popularity.first[1]}.sort

    most_popular_str = most_popular_days.length > 1 ? "Tie (#{most_popular_days.map{|day| days_of_week[day[0]]}.join(', ')})" : days_of_week[most_popular_days[0][0]]
    least_popular_str = least_popular_days.length > 1 ? "Tie (#{least_popular_days.map{|day| days_of_week[day[0]]}.join(', ')})" : days_of_week[least_popular_days[0][0]]

    {most: most_popular_str, least: least_popular_str}
  end

  def hour_stats
    weekdays = @runs.map{|r| r.date.hour}
    sorted_popularity = weekdays.inject(Hash.new(0)) do |sum_arr, hour|
      sum_arr[hour] += 1
      sum_arr
    end

    sorted_popularity = fill_in_missing(sorted_popularity, 23)
    sorted_popularity = sorted_popularity.sort_by{|hour| hour[1]}
    most_popular_hours = sorted_popularity.select{|hour_data| hour_data[1] == sorted_popularity.last[1]}.sort
    least_popular_hours = sorted_popularity.select{|hour_data| hour_data[1] == sorted_popularity.first[1]}.sort

    most_popular_formatted_hours = most_popular_hours.map{|hour_data| pretty_time(hour_data[0], hours: true, pad: true)}
    least_popular_formatted_hours = least_popular_hours.map{|hour_data| pretty_time(hour_data[0], hours: true, pad: true)}

    most_popular_str = most_popular_formatted_hours.length > 1 ? "Tie (#{most_popular_formatted_hours.join(', ')})" : most_popular_formatted_hours[0]
    least_popular_str = least_popular_formatted_hours.length > 1 ? "Tie (#{least_popular_formatted_hours.join(', ')})" : least_popular_formatted_hours[0]

    {most: most_popular_str, least: least_popular_str}
  end

  def fill_in_missing(list, max)
    (max + 1).times do |n|
      list[n] = 0 unless list.has_key?(n)
    end
    list
  end
end