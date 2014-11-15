window.dataPreprocessor = null

class ChartManager
    SpeedCoefficient = 3.6

    constructor: (chartId) ->
        if chartId == undefined
            throw new Error('chartId must not be null')

        @chartId = chartId
        @interval = null
        @data = null

    setData: (data) ->
        if data == null || data == undefined
            throw new Error('Data is null')

        @data = data

        if @interval != null
            @drawSpecificData()

    setInterval: (interval) ->
        if interval == null || interval == undefined
            throw new Error('Data is null')

        @interval = interval

        if @data != null
            @drawSpecificData()

    getDataForInterval: () ->
        if @interval == null
            console.log('Interval not initialized')
            return

        if @data == null
            console.log('Data not initialized')
            return

        dataset = []

        for el in @data
            excelTime = el[2]
            date = excelTimeToDate(excelTime)

            if date.getTime() >= @interval.start.getTime() && date.getTime() <= @interval.end.getTime()
                dataset.push(clone(el))

        return dataset

    drawSpecificData: () ->
        if @interval == null
            console.log('Interval not initialized')
            return

        if @data == null
            console.log('Data not initialized')
            return

        chartData = []

        dataset = @getDataForInterval()

        if dataPreprocessor != null
            dataset = dataPreprocessor(dataset)

        for el in dataset
            excelTime = el[2]
            date = excelTimeToDate(excelTime)

            switch el[0]
                when 1
                    chartData.push({
                        date: date,
                        ax:   el[3],
                        ay:   el[4],
                        az:   el[5]
                    })
                when 4
                    chartData.push({
                        date: date,
                        gx:   el[3],
                        gy:   el[4],
                        gz:   el[5]
                    })
                when 'geo'
                    if excelTime != 'excel time'

                        chartData.push({
                            date:  date,
                            speed: el[9] * SpeedCoefficient
                        })

        fields = ['ax', 'ay', 'az', 'gx', 'gy', 'gz', 'speed']
        @draw(fields, chartData)

    generateGraphs: (fields) ->

        valueAxisMap = {
            'ax' : 'acc',
            'ay' : 'acc',
            'az' : 'acc',
            'gx' : 'gyro',
            'gy' : 'gyro',
            'gz' : 'gyro',
            'speed' : 'speed'
        }

        colorMap = {
            'ax' : '#009900',
            'ay' : '#3366FF',
            'az' : '#FF3300',
            'gx' : '#009900',
            'gy' : '#3366FF',
            'gz' : '#FF3300',
            'speed' : '#FF9900'
        }

        thiknessMap = {
            'ax' : 1,
            'ay' : 1,
            'az' : 1,
            'gx' : 1,
            'gy' : 1,
            'gz' : 1,
            'speed' : 1
        }

        graphs = []
        for field in fields
            graph = {
                "valueAxis": valueAxisMap[field],
                "lineColor": colorMap[field],
                "lineThickness" : thiknessMap[field],
                "bullet": "round",
                "bulletBorderThickness": 1,
                "hideBulletsCount": 30,
                "title": field,
                "valueField": field,
                "fillAlphas": 0
            }
            graphs.push(graph)

        return graphs

    draw: (fields, chartData) ->
        if chartData.length == 0
            console.log('Empty chart data')

        @chart = AmCharts.makeChart(@chartId, {
            "type": "serial",
            "theme": "light",
            "pathToImages": "amcharts/images/",
            "dataProvider": chartData,
            "valueAxes": [{
                "id":"acc",
                "axisColor": "#009900",
                "axisThickness": 3,
                "gridAlpha": 0,
                "axisAlpha": 1,
                "position": "left",
                "maximum" : 13,
                "minimum" : -13 - 26
            },
            {
                "id":"gyro",
                "axisColor": "#009900",
                "axisThickness": 2,
                "gridAlpha": 0,
                "axisAlpha": 1,
                "offset" : 35,
                "position": "left",
                "maximum" : 0.3 + 0.6,
                "minimum" : -0.3
            },
            {
                "id":"speed",
                "axisColor": "#FF9900",
                "axisThickness": 2,
                "gridAlpha": 0,
                "axisAlpha": 1,
                "offset" : 70,
                "position": "left"
            }],
            "graphs": @generateGraphs(fields),
            "chartScrollbar": {},
            "chartCursor": {
                "cursorPosition": "mouse",
                "categoryBalloonDateFormat" : "JJ:NN:SS fff, DD MMMM"
            },
            "categoryField": "date",
            "categoryAxis": {
                "parseDates": true,
                "minPeriod": "fff",
                "axisColor": "#DADADA",
                "minorGridEnabled": true
            }
        })


window.ChartManager = ChartManager
