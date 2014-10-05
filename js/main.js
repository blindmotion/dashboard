(function localFileVideoPlayerInit(win) {
    var URL = win.URL || win.webkitURL,
        displayMessage = (function displayMessageInit() {
            var node = document.querySelector('#message');

            return function displayMessage(message, isError) {
                node.innerHTML = message;
                node.className = isError ? 'error' : 'info';
            };
        }()),

        playSelectedFile = function playSelectedFileInit(event) {
            var file = this.files[0];
            var type = file.type;
            var videoNode = document.getElementById('player');
            var canPlay = videoNode.canPlayType(type);

            canPlay = (canPlay === '' ? 'no' : canPlay);

            var message = 'Can play type "' + type + '": ' + canPlay;
            var isError = canPlay === 'no';

            displayMessage(message, isError);

            if (isError) {
                return;
            }

            var fileURL = URL.createObjectURL(file);

            videoNode.src = fileURL;
            videoNode.playbackRate = 4.0;
        },

        inputNode = document.getElementById('fileInput');

    if (!URL) {
        displayMessage('Your browser is not ' +
            '<a href="http://caniuse.com/bloburls">supported</a>!', true);

        return;
    }

    inputNode.addEventListener('change', playSelectedFile, false);
}(window));