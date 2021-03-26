function Gallery(gallery) {
  const thumbClass = "js-Gallery-thumb";
  const linkClass = "Gallery-link";
  const openStateClass = "is-open";
  const openBodyClass = "gallery-open";

  const view = gallery.querySelector(".Gallery-view");
  const nav = gallery.querySelector(".Gallery-nav");
  const closeButton = gallery.querySelector(".js-Gallery-close");
  const links = view.querySelectorAll(`.${linkClass}`);
  const current = view.querySelector(".js-Gallery-current");
  const total = view.querySelector(".js-Gallery-total");

  let scrollPos;
  let keyHandler;

  const close = () => {
    document.body.classList.remove(openBodyClass);
    view.classList.remove(openStateClass);
    window.scrollTo(0, scrollPos);
    document.removeEventListener("keyup", keyHandler);
  };

  const renderImage = i => {
    const items = gallery.querySelectorAll(`.${thumbClass}`);
    this.index = i;

    view.classList.add("is-loading");

    const URL = items[i].href;

    let FULL_IMAGE_ELEMENT = view.querySelector("img");
    if (!FULL_IMAGE_ELEMENT) {
      FULL_IMAGE_ELEMENT = new Image();
      view.appendChild(FULL_IMAGE_ELEMENT);
    }

    FULL_IMAGE_ELEMENT.onload = () => {
      view.classList.remove("is-loading");
    };

    if (current) {
      current.innerText = i + 1;
    }

    if (total) {
      total.innerText = items.length;
    }

    FULL_IMAGE_ELEMENT.src = URL;
  };

  const getIndex = direction => {
    const itemsLength = gallery.querySelectorAll(`.${thumbClass}`).length;
    let newIndex;

    if (direction === "prev") {
      if (this.index === 0) {
        newIndex = itemsLength - 1;
      } else {
        newIndex = this.index - 1;
      }
    } else if (this.index === itemsLength - 1) {
      newIndex = 0;
    } else {
      newIndex = this.index + 1;
    }

    return newIndex;
  };

  const open = () => {
    view.classList.add(openStateClass);

    if (nav) {
      if (gallery.querySelectorAll(`.${thumbClass}`).length === 1) {
        nav.setAttribute("hidden", true);
      } else {
        nav.removeAttribute("hidden");
      }
    }

    scrollPos = window.scrollY;
    document.body.classList.add(openBodyClass);

    document.addEventListener("keyup", keyHandler);
  };

  const addPreviewClickHandling = element => {
    renderImage(
      Array.from(gallery.querySelectorAll(`.${thumbClass}`)).indexOf(element)
    );
    open();
  };

  const preloadImage = i => {
    const thumb = gallery.querySelectorAll(`.${thumbClass}`)[i];
    const src = thumb.href;
    const image = new Image();
    image.src = src;
  };

  keyHandler = e => {
    if (e.keyCode === 27) {
      close();
    } else if (e.keyCode === 37) {
      renderImage(getIndex("prev"));
    } else if (e.keyCode === 39) {
      renderImage(getIndex("next"));
    }
  };

  gallery.addEventListener("click", e => {
    const thumb = e.target.closest(`.${thumbClass}`);

    if (thumb) {
      e.preventDefault();
      addPreviewClickHandling(thumb);
    }
  });

  gallery.addEventListener("mouseover", e => {
    const thumb = e.target.closest(`.${thumbClass}`);

    if (thumb) {
      preloadImage(
        Array.from(gallery.querySelectorAll(`.${thumbClass}`)).indexOf(thumb)
      );
    }
  });

  Array.from(links).forEach(el => {
    el.addEventListener(
      "mousemove",
      e => {
        preloadImage(
          getIndex(
            e.target.closest(`.${linkClass}`).getAttribute("data-direction")
          )
        );
      },
      true
    );

    el.addEventListener("click", e => {
      e.preventDefault();
      const DIRECTION = e.target
        .closest(`.${linkClass}`)
        .getAttribute("data-direction");
      renderImage(getIndex(DIRECTION));
    });
  });

  if (closeButton) {
    closeButton.addEventListener("click", e => {
      e.preventDefault();
      close();
    });
  }
}

document.addEventListener("turbo:load", () => {
  Array.from(document.querySelectorAll(".js-Gallery")).forEach(
    gallery => new Gallery(gallery)
  );
});
