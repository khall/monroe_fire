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
    rendered.should =~ /Mvc/
  end

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
end