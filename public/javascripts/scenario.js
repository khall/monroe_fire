(function() {

    App.Scenario = (function() {

        function Scenario() {
            this.direct_factors = ['idle_speed', 'relief_valve'];
            this.answer_str = null;
            this.changes_needed = [];
            this.change_text = '';
            this.pump = null;
        }

        Scenario.prototype.easy = function() {
            var chosen_issues, count, df, discharge, issues, num, num_hoses, num_issues, p, _i, _j;
            num_issues = this.rand(2) + 1;
            num_hoses = this.rand(2) + 1;
            discharge = [];
            for (num = _i = 0; 0 <= num_hoses ? _i <= num_hoses : _i >= num_hoses; num = 0 <= num_hoses ? ++_i : --_i) {
                discharge.push(new App.Valve(this.rand(101), new App.Hose((this.rand(10) + 1) * 50, 1.75, this.rand(51) * 5 - 125)));
            }
            p = new App.Pump(100, discharge, [], 500);
            this.answer_str = p.toStr();
            issues = [];
            chosen_issues = [];
            for (num = _j = 0; 0 <= num_issues ? _j <= num_issues : _j >= num_issues; num = 0 <= num_issues ? ++_j : --_j) {
                count = 0;
                df = this.rand(this.direct_factors.length);
                while (chosen_issues.indexOf(df) !== -1 && count < 100) {
                    df = this.rand(this.direct_factors.length);
                    count++;
                }
                chosen_issues.push(df);
                issues.push(this.direct_factors[df]);
            }
            if (issues.indexOf('idle_speed') !== -1) {
                this.changes_needed.push(['idle speed', p.idle_percentage]);
                this.change_text = "Adjust idle speed. ";
                p.idle_percentage = parseInt(p.idle_percentage * this.rand(100) / 100.0);
            }
            if (issues.indexOf('relief_valve') !== -1) {
                this.changes_needed.push(['relief valve', p.relief_valve]);
                this.change_text += "Adjust relief valve. ";
                p.relief_valve = parseInt(p.relief_valve * this.rand(100) / 100.0);
            }
            return this.pump = p;
        };

        Scenario.prototype.morePressureAllLines = function() {
            var p;
            p = new App.Pump(25, [new App.Valve(100, new App.Hose())], [], 500, 300);
            this.pump = p;
            return this.change_text = "More pressure on all lines. ";
        };

        Scenario.prototype.morePressureOneLine = function() {
            this.createWorkingConditions();
            this.pump.relief_valve = 0;
            this.pump.idle_percentage = 0;
            this.pump.discharge[0].open_percentage = 0;
            return this.change_text = "More pressure on the one line. ";
        };

        Scenario.prototype.lessPressureAllLines = function() {
            var p;
            p = new App.Pump(25, [new App.Valve(100, new App.Hose())], [], 500, 300);
            this.pump = p;
            return this.change_text = "Less pressure on all lines. ";
        };

        Scenario.prototype.lessPressureOneLine = function() {
            return this.change_text = "Less pressure on the one line. ";
        };

        Scenario.prototype.addOnMoreHoseOneLine = function() {};

        Scenario.prototype.compensateForElevatedHose = function() {};

        Scenario.prototype.protectLineFromSurge = function() {};

        Scenario.prototype.chargeSecondLineWhileKeepingFirstConstant = function() {};

        Scenario.prototype.createWorkingConditions = function(num_hoses) {
            var discharge, num, _i;
            if (num_hoses == null) {
                num_hoses = 1;
            }
            discharge = [];
            for (num = _i = 0; 0 <= num_hoses ? _i <= num_hoses : _i >= num_hoses; num = 0 <= num_hoses ? ++_i : --_i) {
                discharge.push(new App.Valve(0, new App.Hose((this.rand(10) + 1) * 50, 1.75, this.rand(51) * 5 - 125)));
            }
            return this.pump = new App.Pump(0, discharge, [], 1000, 600, 0);
        };

        Scenario.prototype.checkAnswer = function(p) {
            return p.toStr() === this.answer_str;
        };

        Scenario.prototype.rand = function(upper_limit) {
            return Math.floor(Math.random() * upper_limit);
        };

        return Scenario;

    })();

}).call(this);