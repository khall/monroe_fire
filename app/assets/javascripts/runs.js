function statistics() {
    if ($('svg').length > 1) {
        $('svg').remove();
    }

    var browserVersion = 10;
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var agent = navigator.userAgent;
        var regex  = new RegExp("MSIE ([0-9]{1,}[\.0-9]{0,})");
        if (regex.exec(agent) != null) {
            browserVersion = parseFloat( RegExp.$1 );
        }
    }
    if (browserVersion < 9) {
        $('#charts').hide();
    } else {
        $('#old_days, #old_hours').hide();

        var data;
        var runType;
    //    var allData = #{raw @runs.map{|r| {run_type: r.run_type, weekday: r.date.wday, hour: r.date.to_time.hour}}.to_json};
        var allData = eval($('#all_data.js_interface').html());
    $('#chart_filter').bind('change', function(ev){
        runType = $('#chart_filter').val().toLowerCase().replace(' ', '_');
        // update charts with filtered data
        if (runType == "all") {
            data = allData;
        } else {
            data = _.filter(allData, function(r){ return r.run_type == runType })
        }

        // weekday & hour reductions

        weekdayData = [0, 0, 0, 0, 0, 0, 0];
        _.each(data, function(r){
            weekdayData[r.weekday] += 1;
        });

        hourData = [0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0];
        _.each(data, function(r){
            hourData[r.hour] += 1;
        });

        // convert to num/name hashes

        weekdayHash = [{"name": "Sunday", "num": weekdayData[0]},
            {"name": "Monday", "num": weekdayData[1]},
            {"name": "Tuesday", "num": weekdayData[2]},
            {"name": "Wednesday", "num": weekdayData[3]},
            {"name": "Thursday", "num": weekdayData[4]},
            {"name": "Friday", "num": weekdayData[5]},
            {"name": "Saturday", "num": weekdayData[6]}
        ];

        hourHash = [];
        _.each(hourData, function(r, i){
            hourHash[i] = {"name": i, "num": r};
        })

        svgDays.selectAll(".bar")
            .data(weekdayHash)
            .transition()
            .duration(300)
            .attr("class", "bar")
            .attr("x", function(d) { return xDays(d.name); })
            .attr("width", xDays.rangeBand())
            .attr("y", function(d) { return yDays(d.num); })
            .attr("height", function(d) { return heightDays - yDays(d.num); });

        svgHours.selectAll(".bar")
            .data(hourHash)
            .transition()
            .duration(300)
            .attr("class", "bar")
            .attr("x", function(d) { return x(d.name); })
            .attr("width", x.rangeBand())
            .attr("y", function(d) { return y(d.num); })
            .attr("height", function(d) { return height - y(d.num); });
    })

    // weekday stats

    var marginDays = {top: 20, right: 20, bottom: 30, left: 40},
        widthDays = 800 - marginDays.left - marginDays.right,
        heightDays = 200 - marginDays.top - marginDays.bottom;

    var xDays = d3.scale.ordinal()
        .rangeRoundBands([0, widthDays], .1);

    var yDays = d3.scale.linear()
        .range([heightDays, 0]);

    var xAxis = d3.svg.axis()
        .scale(xDays)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(yDays)
        .orient("left");

    var svgDays = d3.select("#chart_days").append("svg")
        .attr("width", widthDays + marginDays.left + marginDays.right)
        .attr("height", heightDays + marginDays.top + marginDays.bottom)
        .append("g")
        .attr("transform", "translate(" + marginDays.left + "," + marginDays.top + ")");

    //data = #{raw @unsorted_day_stats.to_json};
    data = eval($('#day_data.js_interface').html());

    data.forEach(function(d) {
        d.num = +d.num;
    });

    xDays.domain(data.map(function(d) { return d.name; }));
    yDays.domain([0, d3.max(data, function(d) { return d.num; })]);

    svgDays.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + heightDays + ")")
        .call(xAxis);

    svgDays.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end");

    svgDays.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return xDays(d.name); })
        .attr("width", xDays.rangeBand())
        .attr("y", function(d) { return yDays(d.num); })
        .attr("height", function(d) { return heightDays - yDays(d.num); });

    // hour stats

    var margin = {top: 20, right: 20, bottom: 30, left: 40},
        width = 800 - margin.left - margin.right,
        height = 200 - margin.top - margin.bottom;

    var x = d3.scale.ordinal()
        .rangeRoundBands([0, width], .1);

    var y = d3.scale.linear()
        .range([height, 0]);

    var xAxis = d3.svg.axis()
        .scale(x)
        .orient("bottom");

    var yAxis = d3.svg.axis()
        .scale(y)
        .orient("left");

    var svgHours = d3.select("#chart_hours").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    //data = #{raw @unsorted_hour_stats.to_json};
    data = eval($('#hour_data.js_interface').html());

    data.forEach(function(d) {
        d.num = +d.num;
    });

    x.domain(data.map(function(d) { return d.name; }));
    y.domain([0, d3.max(data, function(d) { return d.num; })]);

    svgHours.append("g")
        .attr("class", "x axis")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    svgHours.append("g")
        .attr("class", "y axis")
        .call(yAxis)
        .append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", ".71em")
        .style("text-anchor", "end");

    svgHours.selectAll(".bar")
        .data(data)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return x(d.name); })
        .attr("width", x.rangeBand())
        .attr("y", function(d) { return y(d.num); })
        .attr("height", function(d) { return height - y(d.num); });
    }
}

$(function() {
    statistics();
});