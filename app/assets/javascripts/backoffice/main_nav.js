document.addEventListener("turbo:load", () => {
  const mainNav = document.querySelector(".js-mainNav");
  const pageSearch = document.querySelector(".js-pageSearch");

  if (mainNav && pageSearch) {
    const searchButton = document.querySelector(".js-searchButton");

    const navButton = mainNav.querySelector(".js-subNavButton");
    const subNavTargetSelector = `#${navButton.getAttribute("href").slice(1)}`;
    const navTarget = document.querySelector(subNavTargetSelector);

    function closeSearch() { // eslint-disable-line no-inner-declarations
      searchButton.setAttribute("aria-expanded", "false");
      pageSearch.setAttribute("aria-hidden", "true");
      searchButton.blur();
    }

    function closeNav() { // eslint-disable-line no-inner-declarations
      navButton.setAttribute("aria-expanded", "false");
      navTarget.setAttribute("aria-hidden", "true");
      navButton.blur();
    }

    function openSearch() { // eslint-disable-line no-inner-declarations
      closeNav();
      document.querySelector("#search-input").focus();
      searchButton.setAttribute("aria-expanded", "true");
      pageSearch.setAttribute("aria-hidden", "false");
    }

    function openNav() { // eslint-disable-line no-inner-declarations
      closeSearch();
      navButton.setAttribute("aria-expanded", "true");
      navTarget.setAttribute("aria-hidden", "false");
    }

    if (searchButton) {
      searchButton.addEventListener("click", e => {
        e.preventDefault();

        if (searchButton.getAttribute("aria-expanded") === "true") {
          closeSearch();
        } else {
          openSearch();
        }
      });
    }

    if (navButton) {
      navButton.addEventListener("click", e => {
        e.preventDefault();

        if (navTarget.getAttribute("aria-hidden") === "false") {
          closeNav();
        } else {
          openNav();
        }
      });
    }
  }
});
