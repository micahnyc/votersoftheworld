window.fbAsyncInit = ->

	FB.init
		appId: "399187936821393"
		status: true
		cookie: true
		xfbml: true

	FB.getLoginStatus fbLoginStatus

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
	console.log response
	if response.status is "connected"
		$('.vote').html('Voted').addClass 'disabled'

vote = (token, who) ->
	$.post "vote.php",
		vote: who
		access_token: token
	, (data) ->
		j = JSON.parse(data)
		console.log "good vote"  if j.status is 0
		console.log "bad params"  if j.status is -3
		console.log "av"  if j.status is -2

		if who is 0
			TweenLite.to $('#romney'), .3,
				css:
					left: '100%'
			TweenLite.to $('#obama'), .3,
				css:
					right: '0%'
		else
			TweenLite.to $('#romney'), .3,
					css:
						left: '0%'
			TweenLite.to $('#obama'), .3,
				css:
					right: '100%'

getVotes = ->
	$.ajax(url: "http://onlineelection2012.com/num.php").success (data) ->
		j = JSON.parse(data)
		obama_per = Math.round((j.o / (j.o + j.r)) * 100)
		rom_per = Math.round((j.r / (j.o + j.r)) * 100)

		TweenLite.to $("#obama .count"), 3,
			css:
				bottom: obama_per + '%'
			delay: 1

		TweenLite.to $("#romney .count"), 3,
			css:
				bottom: rom_per + '%'
			delay: 1

		obamaT = {percent: 50}
		TweenLite.to obamaT, 3,
			percent: obama_per
			delay: 1
			onUpdate: ->
				$('#obama .count').html Math.floor(Math.round(obamaT.percent)) + '%'

		romneyT = {percent: 50}
		TweenLite.to romneyT, 3,
			percent: rom_per
			delay: 1
			onUpdate: ->
				$('#romney .count').html Math.floor(Math.round(romneyT.percent)) + '%'



setListeners = ->
	$('.check').on 'click', ->
		whichCandidate = $(this).parent().parent().attr 'id'
		notCandidate = (if (whichCandidate is "obama") then 'romney' else 'obama')
		obama = (if (whichCandidate is "obama") then '40%' else '60%')
		romney = (if (whichCandidate is "romney") then '40%' else '60%')

		TweenLite.to $('#' + notCandidate + ' .check'), .3
			css:
				marginLeft: -18

		TweenLite.to $('#' + notCandidate + ' .vote'), .3,
			css:
				opacity: 0
				marginLeft: -60

		TweenLite.to $(this), .3
				css:
					marginLeft: -67

		TweenLite.to $(this).parent().children('.vote'), .3,
			css:
				opacity: 1
				marginLeft: -22

		if $(this).hasClass 'active'
			$('.check').removeClass 'active'

			TweenLite.to $('#romney'), .3,
				css:
					left: '50%'

			TweenLite.to $('#obama'), .3,
				css:
					right: '50%'

			TweenLite.to $('.check'), .3
				css:
					marginLeft: -18

			TweenLite.to $('.vote'), .3,
				css:
					opacity: 0
					marginLeft: -60
		else
			$('.check').removeClass 'active'
			$(this).addClass 'active'

			TweenLite.to $('#obama'), .3,
				css:
					right: obama

			TweenLite.to $('#romney'), .3,
				css:
					left: romney
	$('.vote').on 'click', ->
		unless $(this).hasClass 'disabled_not'
			who = (if ($(this).parent().parent().attr("id") is "obama") then 0 else 1)
			FB.login ((response) ->
				if response.authResponse
					vote response.authResponse.accessToken, who
			),
				scope: "user_location"
	$(window).on 'resize', ->
		if $(window).height() > 775
			$('footer').css
				position: 'fixed'
				bottom: '0px'
				top: 'auto'
		else
			$('footer').css
				position: 'absolute'
				top: '730px'
				bottom: 'auto'
	$(window).resize()