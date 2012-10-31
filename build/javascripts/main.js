(function() {
  var createLogo, fbLoginStatus, getVotes, setListeners, setupShareListeners, vote;

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
    createLogo();
    return setListeners();
  });

  createLogo = function() {
    var i, _results;
    $('h1').append('<div class="stars"></div><div class="stars"></div>');
    i = 0;
    _results = [];
    while (i < 22) {
      console.log(i);
      $('.stars').append('<div class="star">"</div>');
      _results.push(i++);
    }
    return _results;
  };

  fbLoginStatus = function(response) {
    if (response.status === "connected") {
      return $('.vote').html('Voted').addClass('disabled');
    }
  };

  vote = function(token, who) {
    return $.post("http://onlineelection2012.com/vote.php", {
      vote: who,
      access_token: token
    }, function(data) {
      var j;
      j = JSON.parse(data);
      if (j.status === 0) {
        if (who === 0) {
          TweenLite.to($('#romney'), .5, {
            css: {
              left: '100%'
            }
          });
          TweenLite.to($('#obama'), .5, {
            css: {
              right: '0%',
              border: 0
            }
          });
          $('#obama h2').append(' for President!');
        } else {
          TweenLite.to($('#romney'), .5, {
            css: {
              left: '0%'
            }
          });
          TweenLite.to($('#obama'), .5, {
            css: {
              right: '100%',
              border: 0
            }
          });
          $('#romney h2').append(' for President!');
        }
        return TweenLite.to($('.vote, .check'), .5, {
          css: {
            opacity: 0
          },
          delay: .5,
          onComplete: function() {
            $('.vote, .check').hide();
            $('.share-btns').show();
            return TweenLite.to($('.share-btns'), .5, {
              css: {
                opacity: 1
              },
              onComplete: function() {
                return setupShareListeners();
              }
            });
          }
        });
      } else {
        return console.log('Something went wrong with the voting, throw an error.');
      }
    });
  };

  setupShareListeners = function() {
    return $('.share-btns div').on('click', function() {
      var forWho, forWhoName, left, text, top;
      forWho = $(this).parent().parent().parent().attr('id');
      forWhoName = forWho.charAt(0).toUpperCase() + forWho.slice(1);
      if ($(this).hasClass('fb')) {
        FB.ui({
          method: 'feed',
          name: 'Online Election 2012',
          link: 'http://onlineelection2012.com/',
          picture: 'http://onlineelection2012.com/images/' + forWho + '.jpg',
          caption: 'I voted for ' + forWhoName + ' in the Online Election 2012.',
          description: 'Who would win the US Presidential Election 2012, if the internet could decide?'
        }, function(response) {
          if (response && response.post_id) {
            return console.log('Post was published.');
          } else {
            return console.log('Post was not published.');
          }
        });
      }
      if ($(this).hasClass('twitter')) {
        if (forWho === 'obama') {
          text = 'I voted for Barack Obama in the Online Election 2012!';
        }
        if (forWho === 'romney') {
          text = 'I voted for Mitt Romney in the Online Election 2012!';
        }
        left = (screen.width / 2) - (600 / 2);
        top = (screen.height / 2) - (260 / 2);
        window.open('https://twitter.com/intent/tweet?text=' + text + '&hashtags=vote, election, ' + forWho + '&url=http://onlineelection2012.com/', 'Tweet about your vote!', 'width=600, height=260, top=' + top + ', left=' + left);
      }
      if ($(this).hasClass('gplus')) {
        left = (screen.width / 2) - (600 / 2);
        top = (screen.height / 2) - (260 / 2);
        return window.open('https://plus.google.com/share?url=http://onlineelection2012.com', 'Share your vote on Google+!', 'width=600, height=260, top=' + top + ', left=' + left);
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
        delay: .5
      });
      TweenLite.to($("#romney .count"), 3, {
        css: {
          bottom: rom_per + '%'
        },
        delay: .5
      });
      obamaT = {
        percent: 50
      };
      TweenLite.to(obamaT, 3, {
        percent: obama_per,
        delay: .5,
        onUpdate: function() {
          return $('#obama .count').html(Math.floor(Math.round(obamaT.percent)) + '%');
        }
      });
      romneyT = {
        percent: 50
      };
      return TweenLite.to(romneyT, 3, {
        percent: rom_per,
        delay: .5,
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
      if (!$(this).hasClass('disabled')) {
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
    $('.welcome .close, .dim').on('click', function() {
      TweenLite.to($('.welcome'), .2, {
        css: {
          scale: 0
        }
      });
      return TweenLite.to($('.dim'), .5, {
        css: {
          opacity: 0
        },
        onComplete: function() {
          $('.dim').hide();
          return getVotes();
        }
      });
    });
    $(window).on('resize', function() {
      if ($(window).height() > 775) {
        $('footer').css({
          position: 'fixed',
          bottom: 0,
          top: 'auto'
        });
        return $('.ad').css({
          position: 'fixed',
          top: 'auto',
          bottom: 0
        });
      } else {
        $('footer').css({
          position: 'absolute',
          top: 730,
          bottom: 'auto'
        });
        return $('.ad').css({
          position: 'absolute',
          top: 630,
          bottom: 'auto'
        });
      }
    });
    return $(window).resize();
  };

}).call(this);
