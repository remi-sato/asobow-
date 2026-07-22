let map;
let marker;
let searchMarker;
let geocoder;
let currentInfoWindow;
let selectedLocationInfoWindow;

window.initMap = function() {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  const lat = mapElement.dataset.lat;
  const lng = mapElement.dataset.lng;
  const mapMode = mapElement.dataset.mapMode;
  const isTopPage = mapElement.hasAttribute("data-posts");

  const posts = mapElement.dataset.posts
    ? JSON.parse(mapElement.dataset.posts)
    : [];

  const center = lat && lng
    ? {
        lat: parseFloat(lat),
        lng: parseFloat(lng)
      }
    : {
        lat: 35.681236,
        lng: 139.767125
      };

  map = new google.maps.Map(mapElement, {
    zoom: 15,
    center: center
  });

  geocoder = new google.maps.Geocoder();

  setupMapSearch();

  if (isTopPage) {
    setupPostMarkers(posts);
    setupTopMapClick();
    return;
  }

  if (mapMode === "form") {
    if (lat && lng) {
      setPostMarker(center);
    }

    setupNewPostMapClick();
    return;
  }

  if (lat && lng) {
    marker = new google.maps.Marker({
      position: center,
      map: map
    });

    return;
  }

  setupNewPostMapClick();
};


function setupPostMarkers(posts) {
  const groupedPosts = groupPostsByLocation(posts);
  const mapElement = document.getElementById("map");
  const newPostUrl = mapElement?.dataset.newPostUrl;

  Object.values(groupedPosts).forEach(function(postsAtLocation) {
    const firstPost = postsAtLocation[0];

    const position = {
      lat: parseFloat(firstPost.latitude),
      lng: parseFloat(firstPost.longitude)
    };

    const postMarker = new google.maps.Marker({
      position: position,
      map: map
    });

    const postsHtml = postsAtLocation
      .map(function(post) {
        return buildPostInfoHtml(post);
      })
      .join('<hr class="map-info-divider">');

    const averageRatingHtml = buildAverageRatingHtml(postsAtLocation);

    const postCountHtml = postsAtLocation.length > 1
      ? `
        <div class="map-info-count">
          この場所の投稿：${postsAtLocation.length}件
        </div>
      `
      : "";

    const placeNameHtml = `
      <div class="map-info-location">
        📍 ${escapeHtml(firstPost.place_name)}
      </div>
    `;

    const newPostLinkHtml = buildNewPostLinkHtml(
      newPostUrl,
      firstPost
    );

    const infoWindow = new google.maps.InfoWindow({
      content: `
        <div class="map-info-window">
          ${placeNameHtml}
          ${newPostLinkHtml}
          ${postCountHtml}
          ${averageRatingHtml}
          ${postsHtml}
        </div>
      `
    });

    postMarker.addListener("click", function() {
      closeSelectedLocationInfoWindow();

      if (currentInfoWindow) {
        currentInfoWindow.close();
      }

      infoWindow.open(map, postMarker);
      currentInfoWindow = infoWindow;
    });
  });
}


function groupPostsByLocation(posts) {
  return posts.reduce(function(groupedPosts, post) {
    if (!post.latitude || !post.longitude) {
      return groupedPosts;
    }

    const latitude = parseFloat(post.latitude);
    const longitude = parseFloat(post.longitude);

    if (
      Number.isNaN(latitude) ||
      Number.isNaN(longitude)
    ) {
      return groupedPosts;
    }

    const locationKey =
      `${latitude.toFixed(6)},${longitude.toFixed(6)}`;

    if (!groupedPosts[locationKey]) {
      groupedPosts[locationKey] = [];
    }

    groupedPosts[locationKey].push(post);

    return groupedPosts;
  }, {});
}

function buildAverageRatingHtml(posts) {
  const ratings = posts
    .map(function(post) {
      return Number(post.rating);
    })
    .filter(function(rating) {
      return !Number.isNaN(rating);
    });

  if (ratings.length === 0) {
    return `
      <div class="map-info-average-rating">
        平均評価：評価なし
      </div>
    `;
  }

  const total = ratings.reduce(function(sum, rating) {
    return sum + rating;
  }, 0);

  const average = total / ratings.length;

  return `
    <div class="map-info-average-rating">
      平均評価：<i class="fa-solid fa-star map-info-rating-icon"></i>${average.toFixed(1)}
    </div>
  `;
}

function buildPostInfoHtml(post) {
  const imageHtml = post.image_url
    ? `
      <img
        src="${escapeHtml(post.image_url)}"
        alt=""
        class="map-info-image"
      >
    `
    : `
      <div class="map-info-no-image">
        No Image
      </div>
    `;

  const ratingHtml = post.rating
    ? `
      <i class="fa-solid fa-star map-info-rating-icon"></i>
      ${escapeHtml(post.rating)}
    `
    : "評価なし";

  return `
    <div class="map-info-post">
      ${imageHtml}

      <div class="map-info-post-title">
        ${escapeHtml(post.title || "")}
      </div>

      <div class="map-info-rating">
        ${ratingHtml}
      </div>

      <div class="map-info-reactions">
        <span>
          <i class="fa-solid fa-heart map-info-favorite-icon"></i>
          ${post.favorites_count || 0}
        </span>

        <span class="map-info-comment">
          <i
            class="fa-regular fa-comment-dots map-info-comment-icon"
          ></i>
          ${post.comments_count || 0}
        </span>
      </div>

      <div class="map-info-actions">
        <a
          href="/posts/${post.id}"
          data-turbo="false"
          class="map-info-detail-link"
        >
          詳細を見る
        </a>
      </div>
    </div>
  `;
}


function buildNewPostLinkHtml(newPostUrl, post) {
  if (!newPostUrl) return "";

  const params = new URLSearchParams({
    place_name: post.place_name || "",
    address: post.address || "",
    latitude: post.latitude,
    longitude: post.longitude
  });

  const postUrl = `${newPostUrl}?${params.toString()}`;

  return `
    <div class="map-info-new-post">
      <a
        href="${postUrl}"
        data-turbo="false"
        class="btn btn-asobow rounded-pill fw-bold w-100"
      >
        この地点を投稿する
      </a>
    </div>
  `;
}


function setupMapSearch() {
  const searchInput = document.getElementById("map-search-input");
  const searchButton = document.getElementById("map-search-button");
  const errorElement = document.getElementById("map-search-error");

  if (!searchInput || !searchButton) return;

  const searchLocation = function() {
    const keyword = searchInput.value.trim();

    if (keyword === "") {
      showMapSearchError(
        errorElement,
        "住所または施設名を入力してください"
      );

      return;
    }

    hideMapSearchError(errorElement);
    searchButton.disabled = true;

    geocoder.geocode(
      {
        address: keyword,
        region: "JP"
      },
      function(results, status) {
        searchButton.disabled = false;

        if (status !== "OK" || !results[0]) {
          showMapSearchError(
            errorElement,
            "該当する場所が見つかりませんでした"
          );

          return;
        }

        const location = results[0].geometry.location;
        const formattedAddress = results[0].formatted_address;

        map.setCenter(location);
        map.setZoom(16);

        setSearchMarker(location, formattedAddress);

        if (isTopMap()) {
          showSelectedLocationInfo({
            location: location,
            placeName: keyword,
            address: formattedAddress,
            latitude: location.lat(),
            longitude: location.lng()
          });
        }

        updatePostFieldsFromSearch(
          location,
          formattedAddress,
          keyword
        );
      }
    );
  };

  searchButton.addEventListener("click", searchLocation);

  searchInput.addEventListener("keydown", function(event) {
    if (event.key === "Enter") {
      event.preventDefault();
      searchLocation();
    }
  });
}


function setupTopMapClick() {
  map.addListener("click", function(event) {
    if (!event.latLng) return;

    if (event.placeId) {
      event.stop();
    }

    const clickedLocation = event.latLng;
    const latitude = clickedLocation.lat();
    const longitude = clickedLocation.lng();

    hideMapSearchError(
      document.getElementById("map-search-error")
    );

    if (currentInfoWindow) {
      currentInfoWindow.close();
      currentInfoWindow = null;
    }

    setSearchMarker(clickedLocation);

    if (event.placeId) {
      geocoder.geocode(
        {
          placeId: event.placeId
        },
        function(results, status) {
          const result =
            status === "OK" && results[0]
              ? results[0]
              : null;

          const address = result
            ? result.formatted_address
            : "";

          showSelectedLocationInfo({
            location: clickedLocation,
            placeName: "",
            address: address,
            latitude: latitude,
            longitude: longitude
          });
        }
      );

      return;
    }

    geocoder.geocode(
      {
        location: {
          lat: latitude,
          lng: longitude
        }
      },
      function(results, status) {
        const address =
          status === "OK" && results[0]
            ? results[0].formatted_address
            : "";

        showSelectedLocationInfo({
          location: clickedLocation,
          placeName: "",
          address: address,
          latitude: latitude,
          longitude: longitude
        });
      }
    );
  });
}


function showSelectedLocationInfo({
  location,
  placeName,
  address,
  latitude,
  longitude
}) {
  const mapElement = document.getElementById("map");
  const newPostUrl = mapElement?.dataset.newPostUrl;

  if (!newPostUrl) return;

  const params = new URLSearchParams({
    place_name: placeName || "",
    address: address || "",
    latitude: latitude,
    longitude: longitude
  });

  const postUrl = `${newPostUrl}?${params.toString()}`;

  closeSelectedLocationInfoWindow();

  const placeNameHtml = placeName
    ? `
      <div class="map-selected-place-name">
        ${escapeHtml(placeName)}
      </div>
    `
    : "";

  selectedLocationInfoWindow = new google.maps.InfoWindow({
    content: `
      <div class="map-selected-window">
        <div class="map-selected-title">
          選択した地点
        </div>

        ${placeNameHtml}

        <div class="map-selected-address">
          ${escapeHtml(address || "住所を取得できませんでした")}
        </div>

        <a
          href="${postUrl}"
          data-turbo="false"
          class="map-selected-post-link"
        >
          この地点を投稿する
        </a>
      </div>
    `
  });

  selectedLocationInfoWindow.open({
    map: map,
    anchor: searchMarker
  });
}


function closeSelectedLocationInfoWindow() {
  if (!selectedLocationInfoWindow) return;

  selectedLocationInfoWindow.close();
  selectedLocationInfoWindow = null;
}


function setupNewPostMapClick() {
  const latitudeField = document.getElementById("post_latitude");
  const longitudeField = document.getElementById("post_longitude");

  if (!latitudeField || !longitudeField) return;

  map.addListener("click", function(event) {
    if (!event.latLng) return;

    const clickedLocation = event.latLng;
    const clickedLat = clickedLocation.lat();
    const clickedLng = clickedLocation.lng();

    setPostMarker(clickedLocation);

    latitudeField.value = clickedLat;
    longitudeField.value = clickedLng;

    const addressField = document.getElementById("post_address");

    geocoder.geocode(
      {
        location: {
          lat: clickedLat,
          lng: clickedLng
        }
      },
      function(results, status) {
        if (
          status === "OK" &&
          results[0] &&
          addressField
        ) {
          addressField.value = results[0].formatted_address;
        }
      }
    );
  });
}


function updatePostFieldsFromSearch(
  location,
  formattedAddress,
  placeName
) {
  const latitudeField = document.getElementById("post_latitude");
  const longitudeField = document.getElementById("post_longitude");
  const addressField = document.getElementById("post_address");
  const placeNameField = document.getElementById("post_place_name");

  if (!latitudeField || !longitudeField) return;

  latitudeField.value = location.lat();
  longitudeField.value = location.lng();

  if (addressField) {
    addressField.value = formattedAddress;
  }

  if (placeNameField && placeName) {
    placeNameField.value = placeName;
  }

  setPostMarker(location);
}


function setSearchMarker(location, title = "") {
  if (searchMarker) {
    searchMarker.setMap(null);
  }

  searchMarker = new google.maps.Marker({
    position: location,
    map: map,
    title: title
  });
}


function setPostMarker(location) {
  if (marker) {
    marker.setMap(null);
  }

  marker = new google.maps.Marker({
    position: location,
    map: map
  });
}


function isTopMap() {
  const mapElement = document.getElementById("map");

  return mapElement?.hasAttribute("data-posts");
}


function showMapSearchError(errorElement, message) {
  if (!errorElement) return;

  errorElement.textContent = message;
  errorElement.classList.remove("d-none");
}


function hideMapSearchError(errorElement) {
  if (!errorElement) return;

  errorElement.textContent = "";
  errorElement.classList.add("d-none");
}


function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}


document.addEventListener("turbo:load", function() {
  const mapElement = document.getElementById("map");
  if (!mapElement) return;

  if (window.google && window.google.maps) {
    window.initMap();
    return;
  }

  if (document.getElementById("google-maps-script")) return;

  const apiKeyElement = document.querySelector(
    'meta[name="google-maps-api-key"]'
  );

  if (!apiKeyElement) return;

  const apiKey = apiKeyElement.content;
  const script = document.createElement("script");

  script.id = "google-maps-script";
  script.src =
    `https://maps.googleapis.com/maps/api/js?key=${apiKey}` +
    "&loading=async&callback=initMap";

  script.async = true;
  script.defer = true;

  document.head.appendChild(script);
});