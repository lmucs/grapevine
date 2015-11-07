$(function () {

    var sync = Backbone.sync;
    //var ROOT_URL = "http://localhost:8000";
    var ROOT_URL = "https://grapevine.herokuapp.com";

    Backbone.sync = function (method, model, options){
      options.beforeSend = function () {
        this.url = ROOT_URL + this.url;
      };
      return sync.call(this, method, model, options);
    };

    $(".viewOptions").click("on", function () {
        $(".day").toggleClass("calView");
        /*$("td").each(function () { 
            
        })*/
    })

});