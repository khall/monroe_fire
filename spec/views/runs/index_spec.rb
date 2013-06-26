require 'spec_helper'

describe "runs/index" do
  it "renders list of runs" do
    runs = [Fabricate(:run, run_type: 'hazmat'),
            Fabricate(:run, run_type: 'fire'),
            Fabricate(:run, run_type: 'mutual_aid'),
            Fabricate(:run, run_type: 'rescue'),
            Fabricate(:run, run_type: 'burn_complaint'),
            Fabricate(:run, run_type: 'mvc')
    ]
    assign(:runs, runs)
    render
    rendered.should =~ /Hazmat/
    rendered.should =~ /Fire/
    rendered.should =~ /Mutual aid/
    rendered.should =~ /Rescue/
    rendered.should =~ /Burn complaint/
    rendered.should =~ /MVC/
  end

  describe "statistics" do
    it "figures out what day of the week has the most calls" do
      runs = [Fabricate(:run, date: DateTime.parse('2013/03/06 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/13 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/20 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/21 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 00:00:00'))
      ]
      assign(:runs, runs)
      render
      rendered.should =~ /Day of the week most likely to have calls: Wednesday/
    end

    it "figures out what day of the week has the least calls" do
      runs = [Fabricate(:run, date: DateTime.parse('2013/03/06 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/07 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/08 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/09 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/10 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/11 00:00:00')),
      ]
      assign(:runs, runs)
      render
      rendered.should =~ /Day of the week least likely to have calls: Tuesday/
    end

    it "figures out what day of the week has the most calls, handling a tie" do
      runs = [Fabricate(:run, date: DateTime.parse('2013/03/06 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/13 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/24 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/21 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 00:00:00'))
      ]
      assign(:runs, runs)
      render
      rendered.should =~ /Day of the week most likely to have calls: Tie \(Tuesday, Wednesday\)/
    end

    it "figures out what day of the week has the least calls, handling a tie" do
      runs = [Fabricate(:run, date: DateTime.parse('2013/03/06 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/13 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/24 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/21 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 00:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 00:00:00'))
      ]
      assign(:runs, runs)
      render
      rendered.should =~ /Day of the week least likely to have calls: Tie \(Monday, Friday, Saturday\)/
    end

    it "figures out what time of day has the most calls" do
      runs = [Fabricate(:run, date: DateTime.parse('2013/03/06 15:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/13 15:50:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/20 13:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/21 12:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 03:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 22:00:00'))
      ]
      assign(:runs, runs)
      render
      rendered.should =~ /Hour of day most likely to have calls: 15:00/
    end

    it "figures out what time of day has the least calls" do
      runs = []
      23.times do |n|
        runs << Fabricate(:run, date: DateTime.parse("2013/03/13 0#{n}:00:00"))
      end

      assign(:runs, runs)
      render
      rendered.should =~ /Hour of day least likely to have calls: 23:00/
    end

    it "figures out what time of day has the most calls, handling a tie" do
      runs = [Fabricate(:run, date: DateTime.parse('2013/03/06 15:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/13 15:50:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/20 13:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/21 12:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 03:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 22:00:00')),
              Fabricate(:run, date: DateTime.parse('2013/03/19 22:30:00'))
      ]
      assign(:runs, runs)
      render
      rendered.should =~ /Hour of day most likely to have calls: Tie \(15:00, 22:00\)/
    end

    it "figures out what time of day has the least calls, handling a tie" do
      runs = []
      22.times do |n|
        runs << Fabricate(:run, date: DateTime.parse("2013/03/13 0#{n}:00:00"))
      end
      assign(:runs, runs)
      render
      rendered.should =~ /Hour of day least likely to have calls: Tie \(22:00, 23:00\)/
    end

    # end statistics
    it "determines the average personnel response for zero runs" do
      runs = []
      assign(:runs, runs)
      render
      rendered.should =~ /Average \(mean\) personnel response: 0/
    end

    it "determines the average personnel response for some runs" do
      runs = [Fabricate(:run, number_of_responders: 4), Fabricate(:run, number_of_responders: 7)]
      assign(:runs, runs)
      render
      rendered.should =~ /Average \(mean\) personnel response: 5/
    end

    it "determines the total time on calls for some runs" do
      runs = [Fabricate(:run, date: Time.now, in_quarters_time: Time.now + 50.minutes),
              Fabricate(:run, date: Time.now, in_quarters_time: Time.now + 70.minutes)]
      assign(:runs, runs)
      render
      rendered.should =~ /Total time on calls: 2 hours/
    end

    it "determines the total man hours on calls for some runs" do
      runs = [Fabricate(:run, date: Time.now, in_quarters_time: Time.now + 52.minutes, number_of_responders: 10),
              Fabricate(:run, date: Time.now, in_quarters_time: Time.now + 70.minutes, number_of_responders: 8)]
      assign(:runs, runs)
      render
      rendered.should =~ /Total man hours: 18/
    end

    it "determines the average time to go in route for zero runs" do
      runs = []
      assign(:runs, runs)
      render
      rendered.should =~ /Average \(mean\) time to go in route: 0 minutes/
    end

    it "determines the average time to go in route for some runs" do
      runs = [Fabricate(:run, date: Time.now, in_route_time: Time.now + 5.minutes),
              Fabricate(:run, date: Time.now, in_route_time: Time.now + 7.minutes)]
      assign(:runs, runs)
      render
      rendered.should =~ /Average \(mean\) time to go in route: 6 minutes/
    end

    it "determines the average time to arrive for zero runs" do
      runs = []
      assign(:runs, runs)
      render
      rendered.should =~ /Average \(mean\) time to arrive: 0 minutes/
    end

    it "determines the average time to arrive for some runs" do
      runs = [Fabricate(:run, date: Time.now, arrived_time: Time.now + 5.minutes),
              Fabricate(:run, date: Time.now, arrived_time: Time.now + 7.minutes)]
      assign(:runs, runs)
      render
      rendered.should =~ /Average \(mean\) time to arrive: 6 minutes/
    end
  end
end