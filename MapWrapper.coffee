###
 * New coffeescript file
###
class MarkerModel
	constructor:(map,lat,long,@html,title)->
		@position=new google.maps.LatLng(lat,long)
		@marker=new google.maps.Marker({
			position: @position,
			map:map,
			title:title
			})
	
	getObject: ->
		markerObj=
			html: @html
			position:@position
			googleMarker:@marker
		markerObj
			
		
	
			
class @MapWrapper # Makes the class Global, so i can access it via javascript
	
	constructor:->
		@infoWindow=new google.maps.InfoWindow()
		@bounds = new google.maps.LatLngBounds()
		mapOptions=
			mapTypeId: google.maps.MapTypeId.ROADMAP
		@map=new google.maps.Map(document.getElementById("map-canvas"), mapOptions)
		@map.setTilt(45)
		boundsListener = google.maps.event.addListener @map, 'bounds_changed', ->
	        @.setZoom(14);
    	    google.maps.event.removeListener(boundsListener);
		
	addMarkerForAd:(ad,lat,long)->
		adHtml=generateHtmlForAd(ad)	
		model = new MarkerModel(@map,lat,long,adHtml,'titile');
		currentMarker=model.getObject()
		if(currentMarker?)
			addListener(@map,@infoWindow,currentMarker)
			@bounds.extend(currentMarker.position)
			@map.fitBounds(@bounds)
			#@map.setZoom(50)
		
		
	refresh:->
		google.maps.event.trigger(@map, 'resize')
		
	addListener=(map,infoWindow,marker)->
		googleMarker=marker.googleMarker
		html=marker.html
		google.maps.event.addListener googleMarker, 'click', ->
            infoWindow.setContent(html)
            infoWindow.open(map,googleMarker)
	
	generateHtmlForAd=(ad)->
		html='<div class="info_content">' +
        '<h3>'+ad.title+'</h3>' +
        '<p>'+ad.desc+'</p>' +  
        '</div>'
		