window.addEventListener('load', chart.rerender, false);
document.getElementById('dataFile').addEventListener('change', fileReader.handleFileSelect, false);
fileReader.on('chartLoaded', chart.updateDataset);
chart.on('conditionChanged', chart.rerender);

//window.addEventListener('load', function(evt) {cerr('load is ok');}, false);