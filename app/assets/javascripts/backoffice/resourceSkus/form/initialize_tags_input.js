import Tagify from '@yaireo/tagify';

function initializeTagify() {
  if (!document.querySelector("tags.js-ResourceSkuForm-TagInput")) {
    const tagInput = document.querySelector("input.js-ResourceSkuForm-TagInput")
    new Tagify(tagInput, { // eslint-disable-line no-new
      enforceWhitelist: true,
      whitelist: JSON.parse(tagInput.dataset.tags)
    })
  }
}

document.addEventListener("turbo:load", () => {
  if (document.querySelector(".js-ResourceSkuForm")) {
    initializeTagify();
  }
});