# Copyright (c) 2014, Blind Motion Project
# All rights reserved.

editor = null

onVideoTimeChanged = () ->
    videoNode = $('#player')
    timePlace = $('#time-place')
    videoTime = videoNode[0].currentTime

    if interval?
        date = new Date(interval.start.getTime() + Math.round(videoTime * 1000))
        currentDate = date
        m = moment(date)
        timePlace.text(m.format("HH:mm:ss"))

        chart.showCursorAt(date)

window.onVideoTimeChanged = onVideoTimeChanged

evalPreprocessCode = () ->
    compiledSource = coffeescript.compile(editor.getValue())
    eval(compiledSource)

onPreprocessorSave = () ->
    evalPreprocessCode()

    if typeof(Storage) != "undefined"
        localStorage.setItem("code", editor.getValue())

    chart.drawSpecificData()

window.coffeemain = () ->
    editor = ace.edit("code-editor")
    editor.setTheme("ace/theme/monokai")
    editor.getSession().setMode("ace/mode/coffee")

    $('#button-save').click(onPreprocessorSave)

    initControlPanel()

    chart = new ChartManager('main-chart')

    window.fileLoader.bind('load', (err, data) =>
        if err == null
            chart.setData(data)
        else
            console.log(err)
    )

    srtInputManager = new FileSelectorManager('srtInput', 'srtInputLabel')
    srtInputManager.bind('change', (input, event) =>
        filename = event.target.files[0].name
        extPos = filename.lastIndexOf('.')
        window.currentFileNameBase = filename.substring(0, extPos)

        getDataFromFile(event.target.files[0], (data) =>
            interval = getIntervalFromSrt(data)
            chart.setInterval(interval)
            window.srtLoaded = true
        )
    );

    eventsInputManager = new FileSelectorManager('eventsFileInput', 'eventsFileLabel')
    eventsInputManager.bind('change', (input, event) =>
        getDataFromFile(event.target.files[0], (data) =>
            events = JSON.parse(data)
            chart.removeAllEventsFromChart()
            for event in events
                 chart.addEventToChart(event)
        )
    );

    window.srtLoaded = false

    dataInputManager = new FileSelectorManager('dataFileInput', 'dataFileLabel');
    dataInputManager.bind('change', (input, event) =>
        window.fileLoader.loadFromFile(event)
    );

    if typeof(Storage) != "undefined"
        code = localStorage.getItem("code")
        if code != null
            editor.setValue(localStorage.getItem("code"))
            evalPreprocessCode()

    $('#main-chart').dblclick( (event) =>
        videoNode = document.getElementById('player')
        videoNode.currentTime = Math.round(chart.lastSelectedTime/1000) )
