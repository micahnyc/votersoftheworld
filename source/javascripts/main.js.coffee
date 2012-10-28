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



$ ->
	setListeners()
	getVotes()

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
	$('#obama .check').on 'click', ->
		if $(this).hasClass 'active'
			$('.check').removeClass 'active'
			TweenLite.to $('#obama'), .3,
				css:
					right: '50%'
			TweenLite.to $('#romney'), .3,
				css:
					left: '50%'
		else
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
			$('.check').removeClass 'active'
			TweenLite.to $('#obama'), .3,
				css:
					right: '50%'
			TweenLite.to $('#romney'), .3,
				css:
					left: '50%'
		else
			$('.check').removeClass 'active'
			$(this).addClass 'active'
			TweenLite.to $('#obama'), .3,
				css:
					right: '60%'
			TweenLite.to $('#romney'), .3,
				css:
					left: '40%'