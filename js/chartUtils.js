
// Debug output
function cerr(s) {
    chartDebugOutput.innerHTML = chartDebugOutput.innerHTML + s + '<br>';
}

// Applies function f for elements of arr
function map(f, arr) {
    var result = [];
    for (var i = 0; i < arr.length; i++) {
        result[i] = f(arr[i]);
    }
    return result;
}

// Returns table version of dataset
function showDataset(dataset) {
    var output = [];
    output.push('<tr>');
    for (var i = 0; i < dataset.colnames.length; i++) {
        output.push('<th>', dataset.colnames[i], '</th>');
    }
    output.push('</tr>');
    for (i = 0; i < dataset.vals.length; i++) {
        output.push('<tr>');
        for (var j = 0; j < dataset.vals[i].length; j++) {
            output.push('<td>', dataset.vals[i][j], '</td>');
        }
        output.push('</tr>');
    }
    return '<table border="1">' + output.join('') + '</table>'
}
