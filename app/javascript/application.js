import "@hotwired/turbo-rails"
import "controllers"
import "map"
import "raty"

document.addEventListener("click", (event) => {
  const button = event.target.closest("#menuButton");
  if (!button) return;
  const menu = document.getElementById("hamburgerMenu");
  if (!menu) return;
  menu.classList.toggle("open");
});import "channels"
