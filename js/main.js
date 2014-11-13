var chart = undefined;

function changeSpeed ()
{
    var videoNode = document.getElementById('player');
    var speedSlider = document.getElementById('speedSlider');
    var speedOutput = document.getElementById("speedOutput");

    value = parseFloat(speedSlider.value);

    speedOutput.value = value;
    videoNode.playbackRate = value;
}

function test ()
{
    var videoNode = document.getElementById('player');
    var testOutput = document.getElementById("testOutput");
    testOutput.value = videoNode.currentTime;
}

function onLoad() {
    localFileVideoPlayerInit(window);

    chart = new ChartManager('main-chart');

    window.fileLoader.bind('load', function(err, data) {
        if (err == undefined) {
            chart.setData(data);
        } else {
            console.log(err);
        }
    })

    var srtInputManager = new FileSelectorManager('srtInput', 'srtInputLabel');
    srtInputManager.bind('change', function(input, event) {
        getDataFromFile(event, function(data) {
            var interval = getIntervalFromSrt(data);
            chart.setInterval(interval);
        });
    });

    var dataInputManager = new FileSelectorManager('dataFileInput', 'dataFileLabel');
    dataInputManager.bind('change',
        function(input, event) {window.fileLoader.loadFromFile(event)});
}

function localFileVideoPlayerInit(win) {
    var URL = win.URL || win.webkitURL;
    var displayMessage = (function displayMessageInit() {
            var node = document.querySelector('#message');

            return function displayMessage(message, isError) {
                node.innerHTML = message;
                node.className = isError ? 'error' : 'info';
            };
        }());
    var playSelectedFile = function playSelectedFileInit(input, event) {
            var file = input.files[0];
            var videoNode = document.getElementById('player');
            var speedSlider = document.getElementById('speedSlider');
            var fileURL = URL.createObjectURL(file);

            videoNode.src = fileURL;
            videoNode.playbackRate = parseFloat(speedSlider.value);
        };

    var videoNode = document.getElementById('player');

    if (!URL) {
        displayMessage('Your browser is not ' +
            '<a href="http://caniuse.com/bloburls">supported</a>!', true);

        return;
    }

    var videoInputManager = new FileSelectorManager('videoInput', 'videoInputLabel');
    videoInputManager.bind('change', playSelectedFile, false);

    videoNode.addEventListener('timeupdate', test)
};
