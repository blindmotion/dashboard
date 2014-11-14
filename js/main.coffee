
editor = null

onVideoTimeChanged = () ->
    videoNode = $('#player')
    timePlace = $('#time-place')
    videoTime = videoNode[0].currentTime

    if interval?
        date = new Date(interval.start.getTime() + Math.round(videoTime * 1000))
        date = moment(date)
        timePlace.text(date.format("HH:mm:ss"))

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

    chart = new ChartManager('main-chart')

    window.fileLoader.bind('load', (err, data) =>
        if err == null
            chart.setData(data)
        else
            console.log(err)
    )

    srtInputManager = new FileSelectorManager('srtInput', 'srtInputLabel')
    srtInputManager.bind('change', (input, event) =>
        getDataFromFile(event, (data) =>
            interval = getIntervalFromSrt(data)
            chart.setInterval(interval)
        )
    );

    dataInputManager = new FileSelectorManager('dataFileInput', 'dataFileLabel');
    dataInputManager.bind('change', (input, event) =>
        window.fileLoader.loadFromFile(event)
    );

    if typeof(Storage) != "undefined"
        code = localStorage.getItem("code")
        if code != null
            editor.setValue(localStorage.getItem("code"))
            evalPreprocessCode()
