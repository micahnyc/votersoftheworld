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
    console.log(response);
    if (response.status === "connected") {
      return $('.vote').html('Voted').addClass('disabled');
    }
  };

  vote = function(token, who) {
    return $.post("vote.php", {
      vote: who,
      access_token: token
    }, function(data) {
      var j;
      j = JSON.parse(data);
      if (j.status === 0) {
        console.log("good vote");
      }
      if (j.status === -3) {
        console.log("bad params");
      }
      if (j.status === -2) {
        console.log("av");
      }
      if (who === 0) {
        TweenLite.to($('#romney'), .3, {
          css: {
            left: '100%'
          }
        });
        return TweenLite.to($('#obama'), .3, {
          css: {
            right: '0%'
          }
        });
      } else {
        TweenLite.to($('#romney'), .3, {
          css: {
            left: '0%'
          }
        });
        return TweenLite.to($('#obama'), .3, {
          css: {
            right: '100%'
          }
        });
      }
    });
  };

  getVotes = function() {
    return $.ajax({
      url: "http://onlineelection2012.com/num.php"
    }).success(function(data) {
      var j, obamaT, obama_per, rom_per, romneyT;
      j = JSON.parse(data);
      obama_per = Math.round((j.o / (j.o + j.r)) * 100);
      rom_per = Math.round((j.r / (j.o + j.r)) * 100);
      TweenLite.to($("#obama .count"), 3, {
        css: {
          bottom: obama_per + '%'
        },
        delay: 1
      });
      TweenLite.to($("#romney .count"), 3, {
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
          return $('#obama .count').html(Math.floor(Math.round(obamaT.percent)) + '%');
        }
      });
      romneyT = {
        percent: 50
      };
      return TweenLite.to(romneyT, 3, {
        percent: rom_per,
        delay: 1,
        onUpdate: function() {
          return $('#romney .count').html(Math.floor(Math.round(romneyT.percent)) + '%');
        }
      });
    });
  };

  setListeners = function() {
    $('.check').on('click', function() {
      var notCandidate, obama, romney, whichCandidate;
      whichCandidate = $(this).parent().parent().attr('id');
      notCandidate = (whichCandidate === "obama" ? 'romney' : 'obama');
      obama = (whichCandidate === "obama" ? '40%' : '60%');
      romney = (whichCandidate === "romney" ? '40%' : '60%');
      TweenLite.to($('#' + notCandidate + ' .check'), .3, {
        css: {
          marginLeft: -18
        }
      });
      TweenLite.to($('#' + notCandidate + ' .vote'), .3, {
        css: {
          opacity: 0,
          marginLeft: -60
        }
      });
      TweenLite.to($(this), .3, {
        css: {
          marginLeft: -67
        }
      });
      TweenLite.to($(this).parent().children('.vote'), .3, {
        css: {
          opacity: 1,
          marginLeft: -22
        }
      });
      if ($(this).hasClass('active')) {
        $('.check').removeClass('active');
        TweenLite.to($('#romney'), .3, {
          css: {
            left: '50%'
          }
        });
        TweenLite.to($('#obama'), .3, {
          css: {
            right: '50%'
          }
        });
        TweenLite.to($('.check'), .3, {
          css: {
            marginLeft: -18
          }
        });
        return TweenLite.to($('.vote'), .3, {
          css: {
            opacity: 0,
            marginLeft: -60
          }
        });
      } else {
        $('.check').removeClass('active');
        $(this).addClass('active');
        TweenLite.to($('#obama'), .3, {
          css: {
            right: obama
          }
        });
        return TweenLite.to($('#romney'), .3, {
          css: {
            left: romney
          }
        });
      }
    });
    $('.vote').on('click', function() {
      var who;
      if (!$(this).hasClass('disabled_not')) {
        who = ($(this).parent().parent().attr("id") === "obama" ? 0 : 1);
        return FB.login((function(response) {
          if (response.authResponse) {
            return vote(response.authResponse.accessToken, who);
          }
        }), {
          scope: "user_location"
        });
      }
    });
    $(window).on('resize', function() {
      if ($(window).height() > 775) {
        return $('footer').css({
          position: 'fixed',
          bottom: '0px',
          top: 'auto'
        });
      } else {
        return $('footer').css({
          position: 'absolute',
          top: '730px',
          bottom: 'auto'
        });
      }
    });
    return $(window).resize();
  };

}).call(this);
