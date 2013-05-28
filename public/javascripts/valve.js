(function() {

    App.Valve = (function() {

        function Valve(open_percentage, hose, pump) {
            if (open_percentage == null) {
                open_percentage = 0;
            }
            if (hose == null) {
                hose = null;
            }
            if (pump == null) {
                pump = null;
            }
            this.open_percentage = open_percentage;
            if (hose !== null) {
                hose.valve = this;
            }
            this.hose = hose;
            this.pump = pump;
        }

        Valve.prototype.setOpenPercentage = function(percent) {
            if (percent > 100) {
                percent = 100;
            }
            if (percent < 0) {
                percent = 0;
            }
            return this.open_percentage = percent;
        };

        Valve.prototype.pressureOut = function() {
            var po;
            po = (this.open_percentage / 100.0) * this.pump.pressure();
            return parseFloat(po.toFixed(1));
        };

        Valve.prototype.toStr = function(with_pump) {
            var hose_str, pump;
            if (with_pump == null) {
                with_pump = false;
            }
            hose_str = this.hose.toStr();
            pump = with_pump ? ",pump:" + this.pump.toStr() : "";
            return "open_percentage:" + this.open_percentage + ",hose:" + hose_str + pump;
        };

        return Valve;

    })();

}).call(this);