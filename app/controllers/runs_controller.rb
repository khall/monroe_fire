class RunsController < ApplicationController
  #before_filter :authenticate_user!, only: [:new, :create]
  #load_and_authorize_resource
  EXCEL_ROWS = 11

  def index
    @runs = Run.this_year
  end

  def new
  end

  def create
    run_array = params[:excel_str].split

    if run_array.length != EXCEL_ROWS
      flash.now[:alert] = "Run was not added. You seem to be missing some data. There needs to be #{EXCEL_ROWS} pieces of data."
      render :new
      return
    end

    type = get_run_type(params[:excel_str])

    run = Run.new
    set_dates(run, run_array)

    run.alarm_number = run_array[1]
    run.run_type = type
    run.number_of_responders = run_array[4]
    run.time_out = run_array[3]

    if run.save
      flash.now[:notice] = "Run added"
    else
      flash.now[:alert] = "Run was not added"
      flash.now[:alert] = "Couldn't match the type of run with string" if type.nil?
    end

    render :new
  end

  private

  def get_run_type(str)
    #				1			____
    type_order = ['burn_complaint', 'fire', 'rescue', 'mvc', 'hazmat', 'mutual_aid']
    #                        <-- date ---> run #<-type-->
    match_data = str.match(/^\d+\/\d+\/\d+\t\d+(\t+\d\t+)\d:\d+/)
    position = nil

    if match_data && match_data.length > 0
      type_str = match_data[1]
      position = type_str.index('1') - 1
    end

    if position
      type_order[position]
    else
      nil
    end
  end

  def set_dates(run, run_array)
    if run_array[0].match(%r|\d+/\d+/(\d+)|)[1].length == 2
      date_format = "%D %k:%M"
    else
      date_format = "%m/%d/%Y %k:%M"
    end
    date = DateTime.strptime("#{run_array[0]} #{run_array[7]}", date_format)
    tomorrow_str = (date + 1.day).strftime("%D")

    in_route_time = DateTime.strptime("#{run_array[0]} #{run_array[8]}", date_format)
    arrived_time = DateTime.strptime("#{run_array[0]} #{run_array[9]}", date_format)
    in_quarters_time = DateTime.strptime("#{run_array[0]} #{run_array[10]}", date_format)

    in_route_time += 1.day if in_route_time < date
    arrived_time += 1.day if arrived_time < date
    in_quarters_time += 1.day if in_quarters_time < date

    run.date = date
    run.in_route_time = in_route_time
    run.arrived_time = arrived_time
    run.in_quarters_time = in_quarters_time
  end
end