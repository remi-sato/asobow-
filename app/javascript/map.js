let map;
let marker;
let geocoder;
let currentInfoWindow;

window.initMap = function() {
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

      const imageHtml = post.image_url
        ? `<img src="${post.image_url}"
            style="
              width: 100%;
              height: 120px;
              object-fit: contain;
              border-radius: 8px;
              background: #f8f9fa;
            ">`
        : `
            <div style="
              width: 100%;
              height: 120px;
              background: #f8f9fa;
              color: #6c757d;
              border-radius: 8px;
              display: flex;
              justify-content: center;
              align-items: center;
              font-size: 14px;
            ">
              No Image
            </div>
        `;

      const ratingHtml = post.rating
        ? `<i class="fa-solid fa-star" style="color: #FFD43B;"></i> ${post.rating}`
        : "評価なし";

      const reactionHtml = `
        <div style="margin-top: 6px; color: #666;">
          <i class="fa-solid fa-heart" style="color: #ff5a7a;"></i> ${post.favorites_count || 0}
          <span style="margin-left: 12px;"><i class="fa-regular fa-comment-dots" style="color: #8e7cc3;"></i> ${post.comments_count || 0}</span>
        </div>
      `;

      const infoWindow = new google.maps.InfoWindow({
        content: `
          <div style="width: 180px;">
            ${imageHtml}

            <div style="margin-top: 8px;">
              <strong style="font-size: 16px;">${post.place_name || ""}</strong>
            </div>

            <div style="margin-top: 4px;">
              ${ratingHtml}
            </div>

            ${reactionHtml}

            <div style="margin-top: 10px;">
              <a href="/posts/${post.id}" data-turbo="false" style="display: inline-block; padding: 6px 12px; background-color: #8b5e3c; color: white; text-decoration: none; border-radius: 6px;">
                詳細を見る
              </a>
            </div>
          </div>
         `
        });

      marker.addListener("click", function() {
        if (currentInfoWindow) {
          currentInfoWindow.close();
        }

        infoWindow.open(map, marker);
        currentInfoWindow = infoWindow;
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

    };

    document.addEventListener("turbo:load", () => {
      const mapElement = document.getElementById("map");
        if (!mapElement) return;

        if (window.google && window.google.maps) {
          window.initMap();
          return;
        }

        if (document.getElementById("google-maps-script")) return;

      const apiKey = document.querySelector('meta[name="google-maps-api-key"]').content;

      const script = document.createElement("script");
      script.id = "google-maps-script";
      script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&loading=async&callback=initMap`;
      script.async = true;
      script.defer = true;

      document.head.appendChild(script);
});

    