import Raty from "raty-js";

function initializeRaty() {
  const ratingInput = document.querySelector("#post-rating");

  if (ratingInput) {
    ratingInput.innerHTML = "";

    new Raty(ratingInput, {
      scoreName: "post[rating]",
      score: ratingInput.dataset.score || undefined,
      starType: "i",
    }).init();
  }

  document.querySelectorAll(".raty-read-only").forEach((element) => {
    element.innerHTML = "";

    new Raty(element, {
      score: Number(element.dataset.score),
      readOnly: true,
      starType: "i",
    }).init();
  });
}

document.addEventListener("turbo:load", initializeRaty);