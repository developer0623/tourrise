
document.addEventListener("turbo:load", () => {
  function changeEventHandler(event) {
    let seasonParam = '';
    let newLocationHref;

    if (event.target.value.length >= 1) {
      seasonParam = `&season_id=${event.target.value}`;
    }

    if (window.location.href.includes('season_id=')) {
      newLocationHref = window.location.href.replace(/&season_id=\d*/gi, seasonParam);
    } else {
      newLocationHref = `${window.location.href}${seasonParam}`;
    }
    window.location.href = newLocationHref;
  }

  const seasonSelectorEl = document.querySelector(".js-SeasonSelection");

  if (seasonSelectorEl) {
    seasonSelectorEl.addEventListener('change', changeEventHandler);
  }
})