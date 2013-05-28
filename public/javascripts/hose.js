(function() {

    window.App = {};

    App.Hose = (function() {
        var appliance_friction_loss, desired_nozzle_pressure, fog_nozzle_gpm, friction_coefficients, smooth_bore_nozzle_gpm;

        friction_coefficients = {
            1: 150,
            1.5: 24,
            1.75: 15.5,
            2.5: 2,
            3: 0.8,
            4: 0.2,
            5: 0.08,
            6: 0.05
        };

        desired_nozzle_pressure = {
            'smooth bore': 50,
            'master stream': 80,
            'fog': 100
        };

        smooth_bore_nozzle_gpm = {
            '1/4': 13,
            '7/8': 159,
            '15/16': 184,
            '1': 209,
            '9/8': 265,
            '5/4': 326
        };

        fog_nozzle_gpm = {
            '3/2': 100,
            '5/2': 240,
            'master': 750
        };

        appliance_friction_loss = {
            'clappered siamese': 10,
            'portable monitor': 25,
            'standpipe': 25
        };

        function Hose(distance, diameter, elevation, max_pressure, valve, nozzle) {
            if (distance == null) {
                distance = 100;
            }
            if (diameter == null) {
                diameter = 1.75;
            }
            if (elevation == null) {
                elevation = 0;
            }
            if (max_pressure == null) {
                max_pressure = 300;
            }
            if (valve == null) {
                valve = null;
            }
            if (nozzle == null) {
                nozzle = '15/16';
            }
            this.distance = distance;
            this.diameter = diameter;
            this.elevation = elevation;
            this.max_pressure = max_pressure;
            this.valve = valve;
            this.nozzle_str = nozzle;
            this.nozzle_float = eval(nozzle);
        }

        Hose.prototype.friction_loss = function() {
            var fl, gpm;
            gpm = smooth_bore_nozzle_gpm[this.nozzle_str];
            fl = friction_coefficients[this.diameter] * Math.pow(gpm / 100.0, 2) * (this.distance / 100.0);
            return parseFloat(fl.toFixed(3));
        };

        Hose.prototype.appliance_loss = function() {
            return 0;
        };

        Hose.prototype.elevation_loss = function() {
            return this.elevation * 0.434;
        };

        Hose.prototype.total_pressure_loss = function() {
            return (this.friction_loss() + this.appliance_loss() + this.elevation_loss()).toFixed(1);
        };

        Hose.prototype.gallons_per_minute = function() {
            return parseFloat((29.7 * Math.pow(this.nozzle_float, 2) * Math.sqrt(this.nozzle_pressure())).toFixed(1));
        };

        Hose.prototype.gallons_per_second = function() {
            return this.gallons_per_minute() / 60.0;
        };

        Hose.prototype.nozzle_pressure = function() {
            var np;
            np = parseFloat((this.valve.pressureOut() - this.total_pressure_loss()).toFixed(1));
            if (np > 0) {
                return np;
            } else {
                return 0;
            }
        };

        Hose.prototype.pressure = function() {
            return nozzle_pressure();
        };

        Hose.prototype.pressure_for_gpm = function(gpm) {
            return parseFloat(Math.pow(gpm / (29.7 * Math.pow(this.nozzle_float, 2)), 2).toFixed(1));
        };

        Hose.prototype.desiredNozzlePressure = function() {
            var nozzle_type;
            if (this.nozzle_str in smooth_bore_nozzle_gpm) {
                nozzle_type = 'smooth bore';
            } else {
                nozzle_type = 'fog';
            }
            return desired_nozzle_pressure[nozzle_type];
        };

        Hose.prototype.toStr = function(with_valve) {
            var valve;
            if (with_valve == null) {
                with_valve = false;
            }
            valve = with_valve ? this.valve.toStr() : "";
            return "distance:" + this.distance + ",diameter:" + this.diameter + ",elevation:" + this.elevation + ",max_pressure:" + this.max_pressure + valve + ",nozzle:" + this.nozzle_str;
        };

        return Hose;

    })();

}).call(this);