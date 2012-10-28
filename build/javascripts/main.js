(function() {
  var fbLoginStatus, getVotes, setListeners, vote;

  window.fbAsyncInit = function() {
    FB.init({
      appId: "399187936821393",
      status: true,
      cookie: true,
      xfbml: true
    });
    return FB.getLoginStatus(fbLoginStatus);
  };

  (function(d) {
    var id, js, ref;
    js = void 0;
    id = "facebook-jssdk";
    ref = d.getElementsByTagName("script")[0];
    if (d.getElementById(id)) {
      return;
    }
    js = d.createElement("script");
    js.id = id;
    js.async = true;
    js.src = "//connect.facebook.net/en_US/all.js";
    return ref.parentNode.insertBefore(js, ref);
  })(document);

  $(function() {
    setListeners();
    return getVotes();
  });

  fbLoginStatus = function(response) {
    if (response.status === "connected") {
      return $('.vote').html('Voted').addClass('disabled');
    }
  };

  vote = function() {};

  getVotes = function() {
    return $.ajax({
      url: "http://onlineelection2012.com/num.php"
    }).success(function(data) {
      var j, obamaT, obama_per, rom_per, romneyT;
      j = JSON.parse(data);
      obama_per = Math.round((j.o / (j.o + j.r)) * 100);
      rom_per = Math.round((j.r / (j.o + j.r)) * 100);
      TweenLite.to($(".count.obama"), 3, {
        css: {
          bottom: obama_per + '%'
        },
        delay: 1
      });
      TweenLite.to($(".count.romney"), 3, {
        css: {
          bottom: rom_per + '%'
        },
        delay: 1
      });
      obamaT = {
        percent: 50
      };
      TweenLite.to(obamaT, 3, {
        percent: obama_per,
        delay: 1,
        onUpdate: function() {
          return $('.count.obama').html(Math.round(obamaT.percent) + '%');
        }
      });
      romneyT = {
        percent: 50
      };
      return TweenLite.to(romneyT, 3, {
        percent: rom_per,
        delay: 1,
        onUpdate: function() {
          return $('.count.romney').html(Math.round(romneyT.percent) + '%');
        }
      });
    });
  };

  setListeners = function() {
    $('.check').on('click', function() {
      console.log($(this).parent().children('.vote'));
      TweenLite.to($(this), .3, {
        css: {
          marginLeft: -67
        }
      });
      return TweenLite.to($(this).parent().children('.vote'), .3, {
        css: {
          opacity: 1,
          marginLeft: -22
        }
      });
    });
    $('#obama .check').on('click', function() {
      if ($(this).hasClass('active')) {
        TweenLite.to($('.count'), .3, {
          css: {
            left: '50%'
          }
        });
        $('.check').removeClass('active');
        TweenLite.to($('#obama'), .3, {
          css: {
            right: '50%'
          }
        });
        return TweenLite.to($('#romney'), .3, {
          css: {
            left: '50%'
          }
        });
      } else {
        TweenLite.to($('.count'), .3, {
          css: {
            left: '60%'
          }
        });
        $('.check').removeClass('active');
        $(this).addClass('active');
        TweenLite.to($('#obama'), .3, {
          css: {
            right: '40%'
          }
        });
        return TweenLite.to($('#romney'), .3, {
          css: {
            left: '60%'
          }
        });
      }
    });
    $('#romney .check').on('click', function() {
      if ($(this).hasClass('active')) {
        TweenLite.to($('.count'), .3, {
          css: {
            left: '50%'
          }
        });
        $('.check').removeClass('active');
        TweenLite.to($('#obama'), .3, {
          css: {
            right: '50%'
          }
        });
        return TweenLite.to($('#romney'), .3, {
          css: {
            left: '50%'
          }
        });
      } else {
        TweenLite.to($('.count'), .3, {
          css: {
            left: '40%'
          }
        });
        $('.check').removeClass('active');
        $(this).addClass('active');
        TweenLite.to($('#obama'), .3, {
          css: {
            right: '60%'
          }
        });
        return TweenLite.to($('#romney'), .3, {
          css: {
            left: '40%'
          }
        });
      }
    });
    return $('vote').on('click', function() {
      if (!$(this).hasClass('disabled')) {
        return FB.login((function(response) {
          return console.log(response);
        }), {
          scope: "user_location"
        });
      }
    });
  };

}).call(this);
