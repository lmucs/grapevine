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

    var registeringUser = Backbone.Model.extend({
        url: '/register'
    });

    var loginUser = Backbone.Model.extend({
        url: '/login'
    });

    var userInfo;

    $("#signIn").on('click', function () {
        var username = $("#username").val();
        var password = $("#password").val();
        var newUser = new loginUser({
            username: username,
            password: password
        });
        newUser.save({}, {
            success: function (model, response) {
                userInfo = response;
                window.location.href="mainpage.html";
            }, 
            error: function (model, response) {
                $("#fail").html(response.responseJSON.message);
            } 
        });
        console.log("Signed in? :D");
    });

    // ^ v DRY

    $("#signUp").on('click', function () {
        // backbone thissss
        $("#signUp").hide();
        $("#login").hide();
        $("#hiddenStuff").show();
        $("#fail").html("");
    });

    $("#submitNewUser").on('click', function () {
        var username = $("#createUserName").val();
        var password = $("#createPassword").val();
        var regUser = new registeringUser({
            username: username,
            password: password
        });
        regUser.save({}, {
            success: function (model, response) {
                userInfo = response;
                window.location.href="mainpage.html";
            }, 
            error: function (model, response) {
                $("#fail").html(response.responseJSON.message);
            } 
        });
    });

    $("#goBack").on("click", function () {
        $("#signUp").show();
        $("#login").show();
        $("#hiddenStuff").hide();
        $("#fail").html("");
    })
});