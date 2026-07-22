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

  // data-posts属性がある画面をトップ画面と判定
  const isTopPage = mapElement.hasAttribute("data-posts");

  const posts = mapElement.dataset.posts
    ? JSON.parse(mapElement.dataset.posts)
    : [];

  const center = (lat && lng)
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

  // -------------------------
  // トップ画面
  // -------------------------
  if (isTopPage) {
    setupPostMarkers(posts);
    setupTopMapClick();
    return;
  }

  // -------------------------
  // 投稿フォーム
  // -------------------------
  if (mapMode === "form") {
    if (lat && lng) {
      setPostMarker(center);
   }

    setupNewPostMapClick();
    return;
  }

// -------------------------
// 投稿詳細画面
// -------------------------
if (lat && lng) {
  marker = new google.maps.Marker({
    position: center,
    map: map
  });

  return;
}

  // -------------------------
  // 新規投稿画面
  // -------------------------
  setupNewPostMapClick();
};


// ========================================
// トップ画面の投稿ピン
// ========================================

function setupPostMarkers(posts) {
  posts.forEach(function(post) {
    if (!post.latitude || !post.longitude) return;

    const position = {
      lat: parseFloat(post.latitude),
      lng: parseFloat(post.longitude)
    };

    const postMarker = new google.maps.Marker({
      position: position,
      map: map
    });

    const imageHtml = post.image_url
      ? `
        <img
          src="${post.image_url}"
          alt=""
          style="
            width: 100%;
            height: 120px;
            object-fit: contain;
            border-radius: 8px;
            background: #f8f9fa;
          "
        >
      `
      : `
        <div
          style="
            width: 100%;
            height: 120px;
            background: #f8f9fa;
            color: #6c757d;
            border-radius: 8px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 14px;
          "
        >
          No Image
        </div>
      `;

    const ratingHtml = post.rating
      ? `
        <i
          class="fa-solid fa-star"
          style="color: #FFD43B;"
        ></i>
        ${post.rating}
      `
      : "評価なし";

    const reactionHtml = `
      <div style="margin-top: 6px; color: #666;">
        <i
          class="fa-solid fa-heart"
          style="color: #ff5a7a;"
        ></i>
        ${post.favorites_count || 0}

        <span style="margin-left: 12px;">
          <i
            class="fa-regular fa-comment-dots"
            style="color: #8e7cc3;"
          ></i>
          ${post.comments_count || 0}
        </span>
      </div>
    `;

    const infoWindow = new google.maps.InfoWindow({
      content: `
        <div style="width: 180px;">
          ${imageHtml}

          <div style="margin-top: 8px;">
            <strong style="font-size: 16px;">
              ${escapeHtml(post.place_name || "")}
            </strong>
          </div>

          <div style="margin-top: 4px;">
            ${ratingHtml}
          </div>

          ${reactionHtml}

          <div style="margin-top: 10px;">
            <a
              href="/posts/${post.id}"
              data-turbo="false"
              style="
                display: inline-block;
                padding: 6px 12px;
                background-color: #8b5e3c;
                color: white;
                text-decoration: none;
                border-radius: 6px;
              "
            >
              詳細を見る
            </a>
          </div>
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


// ========================================
// 住所・施設名検索
// ========================================

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


// ========================================
// トップ画面で任意の地点をクリック
// ========================================

function setupTopMapClick() {
  map.addListener("click", function(event) {
    if (!event.latLng) return;

    // 地図上の施設名・店名などをクリックした場合、
    // Google標準の吹き出しを表示させない
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

    // 施設名クリックの場合
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

          // Geocoderでは施設名を確実に取得できないため、
          // ひとまず空欄で投稿画面へ渡す
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

    // 地図の何もない場所をクリックした場合
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


// ========================================
// 選択地点の吹き出し
// ========================================

function showSelectedLocationInfo({
  location,
  placeName,
  address,
  latitude,
  longitude
}) {
  const mapElement = document.getElementById("map");
  const newPostUrl = mapElement?.dataset.newPostUrl;

  // 未ログインの場合は投稿リンクを表示しない
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
      <div style="font-weight: bold; margin-bottom: 5px;">
        ${escapeHtml(placeName)}
      </div>
    `
    : "";

  selectedLocationInfoWindow = new google.maps.InfoWindow({
    content: `
      <div style="width: 230px;">
        <div
          style="
            font-size: 15px;
            font-weight: bold;
            margin-bottom: 8px;
          "
        >
          選択した地点
        </div>

        ${placeNameHtml}

        <div
          style="
            font-size: 13px;
            color: #666;
            margin-bottom: 12px;
            line-height: 1.5;
          "
        >
          ${escapeHtml(address || "住所を取得できませんでした")}
        </div>

        <a
          href="${postUrl}"
          data-turbo="false"
          style="
            display: inline-block;
            padding: 8px 14px;
            background-color: #8b5e3c;
            color: white;
            text-decoration: none;
            border-radius: 999px;
            font-weight: bold;
          "
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


// ========================================
// 新規投稿画面で地図をクリック
// ========================================

function setupNewPostMapClick() {
  const latitudeField = document.getElementById("post_latitude");
  const longitudeField = document.getElementById("post_longitude");

  if (!latitudeField || !longitudeField) return;

  map.addListener("click", function(event) {
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


// ========================================
// 新規投稿画面のフォーム更新
// ========================================

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


// ========================================
// マーカー操作
// ========================================

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


// ========================================
// 画面判定
// ========================================

function isTopMap() {
  const mapElement = document.getElementById("map");

  return mapElement?.hasAttribute("data-posts");
}


// ========================================
// エラー表示
// ========================================

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


// ========================================
// HTMLエスケープ
// ========================================

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}


// ========================================
// Google Maps API読み込み
// ========================================

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