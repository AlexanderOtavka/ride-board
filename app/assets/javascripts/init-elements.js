var MaterialDateTimePicker = {
    control: null,
    dateRange: null,
    pickerOptions: null,
    create: function(element){
        if (element.type === 'text')
        {
            var defaultDate = new Date();
            var instances = M.Datepicker.init(element, {
                format:  'yyyy/mm/dd',
                selectMonths: true,
                dismissable: false,
                autoClose: true,
                onClose: function(){
                    self.destroy;
                    var instances = M.Timepicker.init(element, {
                        dismissable: false,
                        onSelect: function(hr, min){
                            element.setAttribute('selectedTime', (hr + ":" + min).toString());
                        },
                        onCloseEnd: function(){
                           element.blur();
                        }
                    });
                    if(element.value != "")
                    {
                        element.setAttribute('selectedDate', element.value.toString());
                    }
                    else
                    {
                        element.value = defaultDate.getFullYear().toString() + "/" + (defaultDate.getMonth() + 1).toString() + "/" + defaultDate.getDate().toString();
                        element.setAttribute('selectedDate', element.value.toString());
                    }
                    var instance = M.Timepicker.getInstance(element);
                    instance.open();
                }
            });
            element.addEventListener('change', function(){
                if(element.value.indexOf(':') > -1){
                    element.setAttribute('selectedTime', element.value.toString());
                    element.value = element.getAttribute('selectedDate') + " " + element.getAttribute('selectedTime');
                    var instance = M.Timepicker.getInstance(element);
                    instance.destroy();
                    element.addEventListener('click', function(e){
                        element.value = "";
                        element.removeAttribute("selectedDate");
                        element.removeAttribute("selectedTime");
                        localStorage.setItem('element', element.getAttribute('id'));
                        MaterialDateTimePicker.create.call(element);
                        element.trigger('click');
                    });
                }
            });
            this.addCSSRules();
            return element;
        }
        else
        {
            console.error("The HTML Control provided is not a valid Input Text type.")
        }
    },
    addCSSRules: function(){
        // document.getElementsByTagName('head')[0].appendChild('<style>div.modal-overlay { pointer-events:none; }</style>');
    },
}

document.addEventListener("turbolinks:load", function() {
  M.AutoInit();
  var start_datetime = document.getElementById('ride_start_datetime');
  var end_datetime = document.getElementById('ride_end_datetime');
  if(start_datetime && end_datetime){
        MaterialDateTimePicker.create(start_datetime);
        MaterialDateTimePicker.create(end_datetime);
  }
  var search_start_datetime = document.getElementById('q_start_datetime_lteq');
  var search_end_datetime = document.getElementById('q_end_datetime_lteq');
  if (search_start_datetime && search_end_datetime){
    MaterialDateTimePicker.create(search_start_datetime);
    MaterialDateTimePicker.create(search_end_datetime);
  }
});
