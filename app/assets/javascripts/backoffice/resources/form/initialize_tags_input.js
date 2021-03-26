import Tagify from '@yaireo/tagify';

function initializeTagify() {
  if (!document.querySelector("tags.js-ResourceForm-TagInput")) {
    const tagInput = document.querySelector("input.js-ResourceForm-TagInput")
    new Tagify(tagInput, { // eslint-disable-line no-new
      enforceWhitelist: true,
      whitelist: JSON.parse(tagInput.dataset.tags)
    })
  }
}

document.addEventListener("turbo:load", () => {
  if (document.querySelector(".js-ResourceForm")) {
    initializeTagify();
  }
});