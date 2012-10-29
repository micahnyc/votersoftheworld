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
	createLogo()
	setListeners()

createLogo = ->
	$('h1').append '<div class="stars"></div><div class="stars"></div>'
	i = 0
	while i < 22
		console.log i
		$('.stars').append '<div class="star">"</div>'
		i++

fbLoginStatus = (response)->
	if response.status is "connected"
		$('.vote').html('Voted').addClass 'disabled'

vote = (token, who) ->
	$.post "http://onlineelection2012.com/vote.php",
		vote: who
		access_token: token
	, (data) ->
		j = JSON.parse(data)
		# console.log "good vote"  if j.status is 0
		# console.log "bad params"  if j.status is -3
		# console.log "av"  if j.status is -2
		if j.status is 0
			if who is 0
				TweenLite.to $('#romney'), .5,
					css:
						left: '100%'
				TweenLite.to $('#obama'), .5,
					css:
						right: '0%'
						border: 0
				$('#obama h2').append ' for President!'
			else
				TweenLite.to $('#romney'), .5,
						css:
							left: '0%'
				TweenLite.to $('#obama'), .5,
					css:
						right: '100%'
						border: 0
				$('#romney h2').append ' for President!'
			TweenLite.to $('.vote, .check'), .5,
				css:
					opacity: 0
				delay: .5
				onComplete: ->
					$('.vote, .check').hide();
					$('.share-btns').show()
					TweenLite.to $('.share-btns'), .5,
						css:
							opacity: 1
						onComplete: ->
							setupShareListeners()
		else
			console.log 'Something went wrong with the voting, throw an error.'

setupShareListeners = ->
	$('.share-btns div').on 'click', ->
		forWho = $(this).parent().parent().parent().attr 'id'
		forWhoName = forWho.charAt(0).toUpperCase() + forWho.slice(1)
		if $(this).hasClass 'fb'
			FB.ui
				method: 'feed'
				name: 'Online Election 2012'
				link: 'http://onlineelection2012.com/'
				picture: 'http://onlineelection2012.com/images/' + forWho + '.jpg'
				caption: 'I voted for ' + forWhoName + ' in the Online Election 2012.'
				description: 'Who would win the US Presidential Election 2012, if the internet could decide?'
			, (response) ->
				if response and response.post_id
					console.log 'Post was published.'
				else
					console.log 'Post was not published.'
		if $(this).hasClass 'twitter'
			if forWho is 'obama'
				text = 'I voted for Barack Obama in the Online Election 2012!'
			if forWho is 'romney'
				text = 'I voted for Mitt Romney in the Online Election 2012!'
			left = (screen.width/2)-(600/2)
			top = (screen.height/2)-(260/2)
			window.open 'https://twitter.com/intent/tweet?text=' + text + '&hashtags=vote, election, ' + forWho + '&url=http://onlineelection2012.com/', 'Tweet about your vote!', 'width=600, height=260, top=' + top + ', left='+left
		if $(this).hasClass 'gplus'
			left = (screen.width/2)-(600/2)
			top = (screen.height/2)-(260/2)
			window.open 'https://plus.google.com/share?url=http://onlineelection2012.com', 'Share your vote on Google+!', 'width=600, height=260, top=' + top + ', left='+left

getVotes = ->
	$.ajax(url: "http://onlineelection2012.com/num.php").success (data) ->
		j = JSON.parse(data)
		obama_per = Math.round((j.o / (j.o + j.r)) * 100)
		rom_per = Math.round((j.r / (j.o + j.r)) * 100)

		TweenLite.to $("#obama .count"), 3,
			css:
				bottom: obama_per + '%'
			delay: .5

		TweenLite.to $("#romney .count"), 3,
			css:
				bottom: rom_per + '%'
			delay: .5

		obamaT = {percent: 50}
		TweenLite.to obamaT, 3,
			percent: obama_per
			delay: .5
			onUpdate: ->
				$('#obama .count').html Math.floor(Math.round(obamaT.percent)) + '%'

		romneyT = {percent: 50}
		TweenLite.to romneyT, 3,
			percent: rom_per
			delay: .5
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
		unless $(this).hasClass 'disabled'
			who = (if ($(this).parent().parent().attr("id") is "obama") then 0 else 1)
			FB.login ((response) ->
				if response.authResponse
					vote response.authResponse.accessToken, who
			),
				scope: "user_location"
	$('.welcome .close, .dim').on 'click', ->
		TweenLite.to $('.welcome'), .2,
			css:
				scale: 0
		TweenLite.to $('.dim'), .5,
			css:
				opacity: 0
			onComplete: ->
				$('.dim').hide()
				getVotes()


	$(window).on 'resize', ->
		if $(window).height() > 775
			$('footer').css
				position: 'fixed'
				bottom: 0
				top: 'auto'
			$('.ad').css
				position: 'fixed'
				top: 'auto'
				bottom: 0
		else
			$('footer').css
				position: 'absolute'
				top: 730
				bottom: 'auto'
			$('.ad').css
				position: 'absolute'
				top: 630
				bottom: 'auto'
	$(window).resize()