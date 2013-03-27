Fabricator(:run) do
  date { Time.now - 10.minutes }
  alarm_number { rand(100) }
  run_type { %w(burn_complaint fire rescue mvc hazmat mutual_aid).sample }
  number_of_responders { rand(15) }
  time_out { rand(120) }
  in_route_time { Time.now }
  arrived_time { Time.now + 5.minutes }
  in_quarters_time { Time.now + rand(120).minutes }
end