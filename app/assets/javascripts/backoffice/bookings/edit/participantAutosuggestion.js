document.addEventListener("turbo:load", () => {
  const bookingEditForm = document.querySelector(".js-BookingEditForm");

  const updateParticipant = (data, formEl) => {
    const participantFields = formEl.querySelector(".js-ParticipantSearch");

    const firstName = participantFields.querySelector('[id$="_first_name"]');
    const lastName = participantFields.querySelector('[id$="_last_name"]');
    const birthdate = participantFields.querySelector('[id$="_birthdate"]');
    const email = participantFields.querySelector('[id$="_email"]');
    const participantTypeSelect = participantFields.querySelector(
      '[id$="_participant_type"]'
    );

    firstName.value = data.attributes.first_name;
    lastName.value = data.attributes.last_name;
    birthdate.value = data.attributes.birthdate;
    email.value = data.attributes.email;
    participantTypeSelect.value = data.attributes.participant_type;
  };

  const fetchCustomer = (id, callback) => {
    fetch(`/api/customers/${id}.json`, {
      method: "GET",
      headers: {
        ContentType: "application/json",
        Accept: "application/json",
      },
    })
      .then((response) => response.json())
      .then((results) => callback(results.data))
      .catch((error) => {
        window.Honeybadger.notify("Cannot fetch customer", error);
      });
  };

  if (bookingEditForm) {
    const initializeParticipantSearch = (participantFormEl) => {
      const originalInput = participantFormEl.getElementsByClassName(
        "Input-element"
      )[0];

      originalInput.addEventListener("input", (e) => {
        if (e.target.value) {
          fetchCustomer(e.target.value, (data) =>
            updateParticipant(data, participantFormEl)
          );
        }
      });
    }

    const newParticipantFormEls = bookingEditForm.querySelectorAll(
      ".js-BookingEditForm-newParticipant"
    );

    newParticipantFormEls.forEach(initializeParticipantSearch);

    bookingEditForm.addEventListener("participantAdded", e => {
      initializeParticipantSearch(e.target);
      e.target.dispatchEvent(new CustomEvent("autocompleteAdded", { bubbles: true }))
    });
  }
});
