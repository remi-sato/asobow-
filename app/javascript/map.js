let map;
let marker;
let geocoder;

function initMap() {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  const center = { lat: 35.681236, lng: 139.767125 };

  map = new google.maps.Map(mapElement, {
    zoom: 12,
    center: center
  });

  geocoder = new google.maps.Geocoder();

  map.addListener("click", function(event) {
    const clickedLocation = event.latLng;

    if (marker) marker.setMap(null);

    marker = new google.maps.Marker({
      position: clickedLocation,
      map: map
    });

    const lat = clickedLocation.lat();
    const lng = clickedLocation.lng();

    document.getElementById("post_latitude").value = lat;
    document.getElementById("post_longitude").value = lng;

    geocoder.geocode({ location: { lat: lat, lng: lng } }, function(results, status) {
      if (status === "OK" && results[0]) {
        document.getElementById("post_address").value = results[0].formatted_address;
        }
    });
  });
}

window.initMap = initMap;