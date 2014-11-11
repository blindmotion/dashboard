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

    window.fileLoader.bind("load", function(err, data) {
        if (err == undefined) {
            chart.drawSpecificData(data);
        } else {
            console.log(err);
        }
    })

    document.getElementById('dataFile').addEventListener('change',
        function(event) {window.fileLoader.loadFromFile(event)}, false);
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
    var playSelectedFile = function playSelectedFileInit(event) {
            var file = this.files[0];
            var videoNode = document.getElementById('player');
            var speedSlider = document.getElementById('speedSlider');
            var fileURL = URL.createObjectURL(file);

            videoNode.src = fileURL;
            videoNode.playbackRate = parseFloat(speedSlider.value);
        };

    var inputNode = document.getElementById('fileInput');
    var videoNode = document.getElementById('player');

    if (!URL) {
        displayMessage('Your browser is not ' +
            '<a href="http://caniuse.com/bloburls">supported</a>!', true);

        return;
    }

    inputNode.addEventListener('change', playSelectedFile, false);
    videoNode.addEventListener('timeupdate', test)
};
