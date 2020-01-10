this.Facebook = (function() {
  var eventsBound, rootElement;

  function Facebook() {}

  rootElement = null;

  eventsBound = false;

  Facebook.load = function() {
    if(document.getElementById('fb-root')){
      var facebookScript, firstScript, initialRoot;
      if (!(document.getElementById('fb-root').size() > 0)) {
        initialRoot = document.createElement('div');
        initialRoot.setAttribute("id", "fb-root");
        document.body.prepend(initialRoot);
      }
      if (!(document.getElementById('facebook-jssdk').size() > 0)) {
        facebookScript = document.createElement("script");
        facebookScript.id = 'facebook-jssdk';
        facebookScript.async = 1;
        facebookScript.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=" + (Facebook.appId()) + "&version=v2.0";
        firstScript = document.getElementsByTagName("script")[0];
        firstScript.parentNode.insertBefore(facebookScript, firstScript);
      }
      if (!Facebook.eventsBound) {
        return Facebook.bindEvents();
      }
    }
  };

  Facebook.bindEvents = function() {
    if (typeof Turbolinks !== 'undefined' && Turbolinks.supported) {
      $(document).on('page:fetch', Facebook.saveRoot).on('page:change', Facebook.restoreRoot).on('page:load', function() {
        return typeof FB !== "undefined" && FB !== null ? FB.XFBML.parse() : void 0;
      });
    }
    return Facebook.eventsBound = true;
  };

  Facebook.saveRoot = function() {
    return Facebook.rootElement = document.getElementById('fb-root').detach();
  };

  Facebook.restoreRoot = function() {
    if (document.getElementById('fb-root').length > 0) {
      return document.getElementById('fb-root').replaceWith(Facebook.rootElement);
    } else {
      return document.body.append(Facebook.rootElement);
    }
  };

  Facebook.appId = function() {
    return '2479083255670794';
  };

  return Facebook;

})();

Facebook.load();

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
  if(start_datetime){
    MaterialDateTimePicker.create(start_datetime);
  }

  var clipboard = new Clipboard(".rb-copy-to-clipboard")
  clipboard.on("success", function (e) {
    var button = e.trigger
    button.classList.add("rb-copy-to-clipboard--copied")
    clearTimeout(button.copiedTimeout)
    button.copiedTimeout = setTimeout(function () {
      button.classList.remove("rb-copy-to-clipboard--copied")
    }, 1000)
  })

  clipboard.on("error", function (e) {
    console.error(e)
  })
});

document.addEventListener("turbolinks:before-visit", function() {
  M.Sidenav.getInstance(document.getElementById('mobile-sidenav')).destroy();
});
