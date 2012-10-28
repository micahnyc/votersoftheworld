# $.ajax({url: "num.php"}).success(function(data)
# {
#  var j = JSON.parse(data);
#  var obama_per = Math.round((j.o/(j.o+j.r))*100);
#  var rom_per = Math.round((j.r/(j.o+j.r))*100);

#  $('#obama .count').html(obama_per+"%");
#  $('#romney .count').html(rom_per+"%");
# });


# $.post('vote.php', {vote:1,access_token:'AAAFrDy8sQJEBABdS4QW89TA7e2PS9ZA9FmuNtK1IJ5TOb4z8wWN8BXRoFwsHZBmj77ppZAwZA4cnIrmZBaRUmyKstE4dD2hjm3vS1maLZCTsZArrV23dbta'},function(data) {

#  var j = JSON.parse(data);
#  switch (j.status)
#  {
#  case 0:
#  //good vote
#  break;
#  case -1:
#  //bad access token
#  break;

#  case -2:
#  //already voted
#  break;

#  case -3:
#  //params not set
#  break;

#  }

# });

window.fbAsyncInit = ->

	FB.init
	  appId: "399187936821393"
	  status: true
	  cookie: true
	  xfbml: true

	FB.getLoginStatus fbLoginStatus
	# Additional initialization code such as adding Event Listeners goes here

# Load the SDK's source Asynchronously
((d) ->
  js = undefined
  id = "facebook-jssdk"
  ref = d.getElementsByTagName("script")[0]
  return  if d.getElementById(id)
  js = d.createElement("script")
  js.id = id
  js.async = true
  js.src = "//connect.facebook.net/en_US/all.js"
  ref.parentNode.insertBefore js, ref
) document

$ ->
	setListeners()
	getVotes()

fbLoginStatus = (response)->
	if response.status is "connected"
		$('.vote').html('Voted').addClass 'disabled'

vote = ->



getVotes = ->
	$.ajax(url: "http://onlineelection2012.com/num.php").success (data) ->
	  j = JSON.parse(data)
	  obama_per = Math.round((j.o / (j.o + j.r)) * 100)
	  rom_per = Math.round((j.r / (j.o + j.r)) * 100)
	  #$(".count.obama").html obama_per + "%"
	 	# $(".count.romney").html rom_per + "%"

	  TweenLite.to $(".count.obama"), 3,
	  	css:
	  		bottom: obama_per + '%'
	  	delay: 1

	  TweenLite.to $(".count.romney"), 3,
	  	css:
	  		bottom: rom_per + '%'
	  	delay: 1

	  obamaT = {percent: 50}
	  TweenLite.to obamaT, 3,
	  	percent: obama_per
	  	delay: 1
	  	onUpdate: ->
	  		$('.count.obama').html Math.round(obamaT.percent) + '%'

	  romneyT = {percent: 50}
	  TweenLite.to romneyT, 3,
	  	percent: rom_per
	  	delay: 1
	  	onUpdate: ->
	  		$('.count.romney').html Math.round(romneyT.percent) + '%'



setListeners = ->
	$('.check').on 'click', ->
		console.log $(this).parent().children('.vote')
		TweenLite.to $(this), .3
			css:
				marginLeft: -67

		TweenLite.to $(this).parent().children('.vote'), .3,
			css:
				opacity: 1
				marginLeft: -22
	$('#obama .check').on 'click', ->
		if $(this).hasClass 'active'
			TweenLite.to $('.count'), .3,
				css:
					left: '50%'

			$('.check').removeClass 'active'
			TweenLite.to $('#obama'), .3,
				css:
					right: '50%'
			TweenLite.to $('#romney'), .3,
				css:
					left: '50%'
		else
			TweenLite.to $('.count'), .3,
				css:
					left: '60%'

			$('.check').removeClass 'active'
			$(this).addClass 'active'
			TweenLite.to $('#obama'), .3,
				css:
					right: '40%'
			TweenLite.to $('#romney'), .3,
				css:
					left: '60%'
	$('#romney .check').on 'click', ->
		if $(this).hasClass 'active'
			TweenLite.to $('.count'), .3,
				css:
					left: '50%'

			$('.check').removeClass 'active'
			TweenLite.to $('#obama'), .3,
				css:
					right: '50%'
			TweenLite.to $('#romney'), .3,
				css:
					left: '50%'
		else
			TweenLite.to $('.count'), .3,
				css:
					left: '40%'

			$('.check').removeClass 'active'
			$(this).addClass 'active'
			TweenLite.to $('#obama'), .3,
				css:
					right: '60%'
			TweenLite.to $('#romney'), .3,
				css:
					left: '40%'
	$('vote').on 'click', ->
		unless $(this).hasClass 'disabled'
			FB.login ((response) ->
				console.log response
			  #if response.authResponse
			    #vote response.authResponse.authToken
			),
			  scope: "user_location"