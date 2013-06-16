function move_bus_to_polyline(bus, polyline)
{
	var min_distance = 1000;
	var point1, point2;
	$.each(polyline, function (index, point)
	{
		if(index < polyline.length - 1)
		{
			middle = {lat: (point.lat + polyline[index + 1].lat)/2 , lng: (point.lng + polyline[index + 1].lng)/2}
			dist = distHaversine(middle , bus);
			if( dist < min_distance )
			{
				console.log('cambio de tramo');
				min_distance = dist;
				point1= point;
				point2 = polyline[index + 1];
			}

		}
	});
	precicion = 10
	var dif_lat = (point1.lat - point2.lat)/precicion
	var dif_lng = (point1.lng - point2.lng)/precicion
	console.log('dif_lat: '+dif_lat+' dif_lng: '+dif_lng);
	min_distance = 1000;
	for (var i=0;i<precicion;i++)
	{
		middle = {lat: point1.lat + dif_lat * i , lng: point1.lng + dif_lng * i}
		dist = distHaversine(middle , bus);
		if( dist < min_distance )
		{
			console.log('cambio de posicion');
			min_distance = dist;
			bus.lat = middle.lat;
			bus.lng = middle.lng;
		}
	}
}


rad = function(x) {return x*Math.PI/180;}

distHaversine = function(p1, p2) {
  var R = 6371; // earth's mean radius in km
  var dLat  = rad(p2.lat - p1.lat);
  var dLong = rad(p2.lng - p1.lng);

  var a = Math.sin(dLat/2) * Math.sin(dLat/2) +
          Math.cos(rad(p1.lat)) * Math.cos(rad(p2.lat)) * Math.sin(dLong/2) * Math.sin(dLong/2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  var d = R * c;

  return d.toFixed(3);
}