var fileReader = {
    readed: {colnames: [], vals: []},

    // Read dataset from chosen file
    handleFileSelect: function(evt) {
        var files = evt.target.files;
        var reader = new FileReader();

        var foo = function(e) {
            var colnames_ = [];
            var vals_ = [];

            var filestr = e.target.result;
            var separators = ['\\n', '\\r'];
            var strs = filestr.split(new RegExp(separators.join('|'), 'g'));
            for (var i = 0; i < strs.length; i++) {
                var s = strs[i];
                if (i == 0) {
                    colnames_ = s.split('\t');
                } else {
                    if (s.length == 0) {
                        continue;
                    }
                    vals_.push(map(parseFloat, s.split('\t')));
                }
            }
            var item = {colnames: colnames_, vals: vals_};
            fileReader.trigger('chartLoaded', item);
        };

        reader.addEventListener('load', (function(f) {return foo}) (files[0]), false);
        reader.readAsText(files[0]);
    },

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
