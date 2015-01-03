/**
 * Copyright (c) 2014, Blind Motion Project
 * All rights reserved.
 */

function changeSpeed ()
{
    var videoNode = document.getElementById('player');
    var speedSlider = document.getElementById('speedSlider');
    var speedOutput = document.getElementById("speedOutput");

    value = parseFloat(speedSlider.value);

    speedOutput.value = value;
    videoNode.playbackRate = value;
}

function onLoad() {
    localFileVideoPlayerInit(window);

    coffeemain();
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
            window.videoLoaded = true;
        };

    var videoNode = document.getElementById('player');

    if (!URL) {
        displayMessage('Your browser is not ' +
            '<a href="http://caniuse.com/bloburls">supported</a>!', true);

        return;
    }

    var videoInputManager = new FileSelectorManager('videoInput', 'videoInputLabel');
    videoInputManager.bind('change', playSelectedFile, false);

    videoNode.addEventListener('timeupdate', onVideoTimeChanged)
    window.videoLoaded = false;
};
