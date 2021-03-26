function removeResource(clickedElement) {
  const result = window.confirm('Are you sure?'); /* eslint-disable-line no-alert */

  if (result) {
    fetch(
      clickedElement.getAttribute('href'),
      {
        method: 'DELETE',
        redirect: 'follow',
        headers: {
          'X-CSRF-Token': document.getElementsByName('csrf-token')[0].content
        }
      }
    ).then(response => {
      if (response.redirected) {
        window.location.href = response.url;
      }
    });
  }
}

document.addEventListener("turbo:load", () => {
  const resourceDetails = document.querySelector(".js-ResourceDetails");

  if (resourceDetails) {
    resourceDetails.addEventListener("click", e => {
      const clickedElement = e.target;
      const deleteResourceButton = clickedElement.closest(
        ".js-ResourceDetails-destroyResourceButton"
      );

      if (deleteResourceButton) {
        e.preventDefault();
        removeResource(deleteResourceButton);
      }
    });
  }
});

