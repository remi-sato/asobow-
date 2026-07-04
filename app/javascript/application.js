import "@hotwired/turbo-rails"
import "controllers"
import "map"

document.addEventListener("turbo:load", () => {
  const button = document.getElementById("menuButton");
  const menu = document.getElementById("hamburgerMenu");

  if (!button) return;

  button.addEventListener("click", () => {
    menu.classList.toggle("open");
  });
});