var randomScalingFactor = function(){ return Math.round(Math.random()*256)};
var randomColor = function(){ return 'rgba(' + randomScalingFactor() + ',' + randomScalingFactor() + ',' + randomScalingFactor() + ',1)';};

var chart = {
    dataset: {colnames: [], vals: []},
    scale: 1,
    currentTime: 0,
    dots: 200,
    colors: [randomColor(),
        randomColor(),
        randomColor(),
        randomColor(),
        randomColor(),
        randomColor(),
        randomColor(),
        randomColor(),
        randomColor(),
        randomColor()],
    fields: [],
    chartData: {labels:[] , datasets: []},
    chart: null,
    initW: 300,
    initH: 150,

    /**
     * Подписка на событие
     * Использование:
     *  menu.on('select', function(item) { ... }
     */
    on: function(eventName, handler) {
        if (!this._eventHandlers) this._eventHandlers = [];
        if (!this._eventHandlers[eventName]) {
            this._eventHandlers[eventName] = [];
        }
        this._eventHandlers[eventName].push(handler);
    },

    /**
     * Прекращение подписки
     *  menu.off('select',  handler)
     */
    off: function(eventName, handler) {
        var handlers = this._eventHandlers[eventName];
        if (!handlers) return;
        for(var i=0; i<handlers.length; i++) {
            if (handlers[i] == handler) {
                handlers.splice(i--, 1);
            }
        }
    },

    /**
     * Генерация события с передачей данных
     *  this.trigger('select', item);
     */
    trigger: function(eventName) {

        if (!this._eventHandlers[eventName]) {
            return; // обработчиков для события нет
        }

        // вызвать обработчики
        var handlers = this._eventHandlers[eventName];
        for (var i = 0; i < handlers.length; i++) {
            handlers[i].apply(this, [].slice.call(arguments, 1));
        }
    }
};

chart.prepareData = function() {
    var labels = [];
    //for (var i = -this.dots, tmp = this.currentTime - this.dots * this.scale; i <= this.dots; i++) {
    //    labels.push(tmp);
    //    tmp += this.scale;
    //}
    var datasets = [];
    for (var i = 0; i < chart.fields.length; i++) {
        if (chart.fields[i] == 0) {
            continue;
        }

        datasets.push({
            label: chart.dataset.colnames[i],
            strokeColor: chart.colors[i],
            fillColor : chart.colors[i],
            pointColor : chart.colors[i],
            pointStrokeColor : "#fff",
            pointHighlightFill : "#fff",
            pointHighlightStroke : this.colors[i],
            data: []
        });
    }
    var vals = chart.dataset.vals;
    for (i = 0; i < vals.length; i++) {
        labels.push(vals[i][0]);
        var cnt = 0;
        for (var j = 0; j < vals[i].length; j++) {
            if (chart.fields[j] == 0) {
                continue;
            }
            datasets[cnt].data.push(vals[i][j]);
            cnt += 1;
        }
    }
    return {labels: labels, datasets: datasets};
};

chart.initGraph = function(item) {
    var cnvs = document.getElementById("canvas");
    cnvs.width = chart.initW;
    cnvs.height = chart.initH;
    var ctx = document.getElementById("canvas").getContext("2d");

    chart.chart = new Chart(ctx).Line(chart.chartData,
        {
            //tooltipTemplate: "<%if (label){%><%=label%>: <%}%><%= name %>",
            //multiTooltipTemplate: "<%= label %>",
            animation: false,
            responsive: true,
            maintainAspectRatio: false,
            bezierCurve: false,
            pointDot: false,
            datasetFill: false
        }
    );
};

chart.rerender = function(item) {
    if (chart.chart != null) {
        chart.chart.destroy();
    }
    chart.chartData = chart.prepareData();
    chart.initGraph();
};

chart.updateFields = function(item) {
    chart.fields = [0];
    for (var i = 1; i < chart.dataset.colnames.length; i++) {
        var id = 'checkChoice' + chart.dataset.colnames[i];
        var chk = document.getElementById(id);
        chart.fields.push((chk.checked) ? 1 : 0);
    }
    chart.trigger('conditionChanged', item);
};

chart.updateDataset = function(item) {
    chart.dataset = item;
    chart.updateChoiceForm(item);
};

chart.updateChoiceForm = function(item) {
    var form = document.getElementById('choiceForm');
    while (form.childNodes.length > 0) {
        form.removeChild(form.childNodes[0]);
    }
    var colnames = item.colnames;
    for (var i = 1; i < colnames.length; i++) {
        var name = colnames[i];
        var lbl = document.createElement('labelChoice' + name);
        lbl.innerHTML = '<label></label>';
        var chk = document.createElement('checkChoice' + name);
        chk.innerHTML = '<input type="checkbox" hidden="false" checked="false" name="chk" class="chartItem" id="' + 'checkChoice' + name + '" value="' + name + '">' + name;
        lbl.appendChild(chk);
        document.getElementById('choiceForm').appendChild(lbl);
        document.getElementById('checkChoice' + name).addEventListener('click', chart.updateFields, false);
    }
    chart.updateFields();
};
