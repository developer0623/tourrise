import Tagify from '@yaireo/tagify';

function initializeTagify(productForm) {
  if (!document.querySelector("tags.js-ProductForm-TagInput")) {
    const tagInput = productForm.querySelector("input.js-ProductForm-TagInput")
    new Tagify(tagInput, { // eslint-disable-line no-new
      enforceWhitelist: true,
      whitelist: JSON.parse(tagInput.dataset.tags)
    })
  }
}

document.addEventListener("turbo:load", () => {
  const productForm = document.querySelector(".js-ProductForm");

  if (productForm) {
    initializeTagify(productForm);
  }
});