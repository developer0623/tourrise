import { DirectUpload } from '@rails/activestorage';

const settings = {
  classes: {
    item: "Gallery-item",
    new: "is-new",
    featuredImage: "Gallery-featuredImage",
    removeImage: "Gallery-removeItem",
    imageId: "Gallery-imageId",
    thumbnailImage: "Gallery-image"
  },
  fileTypes: ["JPG", "JPEG", "PNG"]
};

const selectedFiles = [];
let imagesUploaded;

function FileUpload(files, item, url, index, callback) {
  this.files = files;
  this.item = item;
  this.url = url;
  this.index = index;
  this.callback = callback;

  this.directUpload = new DirectUpload(
    this.files[this.index],
    this.url,
    this
  );

  this.directUpload.create((error, blob) => {
    if (error) {
      // Handle the error
    } else {
      this.callback(this.item, blob);
    }
  });
}

function checkIfFileTypeIsValid(file) {
  const fileTypeParts = file.name.split(".");
  const fileType = fileTypeParts[fileTypeParts.length - 1].toUpperCase();

  return settings.fileTypes.indexOf(fileType) >= 0;
}

function onRemoveImageInputChange(e, file) {
  const index = Array.from(
    document.querySelectorAll(
      `.${settings.classes.item}.${settings.classes.new}`
    )
  ).indexOf(e.target.closest(`.${settings.classes.item}`));

  if (e.target.checked) {
    selectedFiles[index] = null;
  } else {
    selectedFiles[index] = file;
  }
}

function addThumbnailElement(gallery, i) {
  const items = gallery.querySelector(".Gallery-items");
  const template = document.getElementById("Gallery-imageTemplate");
  const node = template.content.firstElementChild.cloneNode(true);
  const featuredInput = node.querySelector(
    `.${settings.classes.featuredImage}`
  );
  const removeInput = node.querySelector(`.${settings.classes.removeImage}`);

  const id = `${Date.now()}-${i}`;

  removeInput.id = removeInput.id.replace("{{ID}}", id);
  removeInput.value = id;
  featuredInput.id = featuredInput.id.replace("{{ID}}", id);
  featuredInput.value = id;

  Array.from(node.querySelectorAll("label")).forEach(label => {
    label.setAttribute("for", label.getAttribute("for").replace("{{ID}}", id));
  });

  items.insertBefore(node, items.lastElementChild);

  return node;
}

function onImageRead(e, gallery, gallerySize, i) {
  gallery
    .querySelector(
      `.${settings.classes.item}:nth-child(${gallerySize + i}) .${
        settings.classes.thumbnailImage
      }`
    )
    .setAttribute("src", e.target.result);
}

function readImage(file, gallery, gallerySize, i) {
  const reader = new FileReader();
  reader.addEventListener(
    "load",
    e => {
      onImageRead(e, gallery, gallerySize, i);
    },
    false
  );
  reader.readAsDataURL(file);
}

function handleFile(file, gallery, gallerySize, i) {
  if (checkIfFileTypeIsValid(file)) {
    const thumbnail = addThumbnailElement(gallery, i);
    const thumbnailRemoveInput = thumbnail.querySelector(
      `.${settings.classes.removeImage}`
    );

    thumbnailRemoveInput.addEventListener("change", e => {
      onRemoveImageInputChange(e, file);
    });

    selectedFiles.push(file);

    readImage(file, gallery, gallerySize, i);
  }
}

function onFileInputChange(gallery, fileInput) {
  const gallerySize = gallery.querySelectorAll(`.${settings.classes.item}`)
    .length;

  Array.from(fileInput.files).forEach((file, i) => {
    handleFile(file, gallery, gallerySize, i);
  });
}

function onImageUploaded(fileInput, newUploadItems, el, blob) {
  const input = fileInput;
  const removeInput = el.querySelector(`.${settings.classes.removeImage}`);
  const hiddenInput = el.querySelector(`.${settings.classes.imageId}`);
  const featuredInput = el.querySelector(`.${settings.classes.featuredImage}`);

  removeInput.value = blob.id;
  hiddenInput.value = blob.signed_id;
  featuredInput.value = blob.id;

  imagesUploaded += 1;

  if (imagesUploaded === newUploadItems.length) {
    input.value = null;
    input.closest("form").submit();
  }
}

function uploadImage(item, input, callback) {
  return new FileUpload(
    selectedFiles,
    item,
    input.dataset.directUpload,
    Array.from(
      document.querySelectorAll(
        `.${settings.classes.item}.${settings.classes.new}`
      )
    ).indexOf(item),
    callback
  );
}

function removeNewItemsThatAreMarkedAsToBeRemoved(newItems) {
  newItems
    .filter(
      item => item.querySelector(`.${settings.classes.removeImage}`).checked
    )
    .forEach(item => {
      item.querySelector(`.${settings.classes.imageId}`).remove();
    });
}

function getNewItems(gallery) {
  return Array.from(
    gallery.querySelectorAll(
      `.${settings.classes.item}.${settings.classes.new}`
    )
  );
}

function getNewItemsThatShouldBeUploaded(newItems) {
  return newItems.filter(
    item => !item.querySelector(`.${settings.classes.removeImage}`).checked
  );
}

function uploadImages(allItems, uploadItems, input) {
  allItems
    .filter(
      item => !item.querySelector(`.${settings.classes.removeImage}`).checked
    )
    .forEach(item =>
      uploadImage(item, input, (el, blob) => {
        onImageUploaded(input, uploadItems, el, blob);
      })
    );
}

function onFormSubmit(e, gallery, fileInput) {
  const input = fileInput;
  const newItems = getNewItems(gallery);
  const newUploadItems = getNewItemsThatShouldBeUploaded(newItems);

  removeNewItemsThatAreMarkedAsToBeRemoved(newItems);

  if (newUploadItems.length > 0) {
    imagesUploaded = 0;
    e.preventDefault();
    uploadImages(newItems, newUploadItems, input);
  } else {
    input.value = null;
  }
}

document.addEventListener("turbo:load", () => {
  const gallery = document.querySelector(".js-GalleryEdit");

  if (gallery) {
    const fileInput = gallery.querySelector(".Gallery-fileUpload");

    fileInput.addEventListener("change", () => {
      onFileInputChange(gallery, fileInput);
    });

    gallery.closest("form").addEventListener("submit", e => {
      onFormSubmit(e, gallery, fileInput);
    });
  }
});
