let map;
let marker;
let geocoder;

function initMap() {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  const lat = mapElement.dataset.lat;
  const lng = mapElement.dataset.lng;

  const posts = mapElement.dataset.posts
    ? JSON.parse(mapElement.dataset.posts)
    : [];

  const center = (lat && lng)
  ? { lat: parseFloat(lat), lng: parseFloat(lng) }
  : { lat: 35.681236, lng: 139.767125 };

  map = new google.maps.Map(mapElement, {
    zoom: 15,
    center: center
  });

  // topページ用
  // トップページ用
if (posts.length > 0) {
  posts.forEach(function(post) {
    const position = {
      lat: parseFloat(post.latitude),
      lng: parseFloat(post.longitude)
    };

    const marker = new google.maps.Marker({
      position: position,
      map: map
    });

    marker.addListener("click", function() {
      window.location.href = `/posts/${post.id}`;
    });
  });

  return;
}

  // show画面用pin表示のみ
  if (lat && lng) {
    marker = new google.maps.Marker({
      position: center,
      map: map
    });
    return;
  }

  // new画面用新しくピン立てる
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