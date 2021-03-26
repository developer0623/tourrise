/* eslint no-param-reassign: 2 */  // --> OFF

import { Turbo } from '@hotwired/turbo-rails';

document.addEventListener("turbo:load", () => {
  const parseTemplate = (template, attributes) => {
    let parsedTemplate = template

    const placeholders =
      template                                   // Grab string value from template variable
      .split(/(?=%{)/)                           // Split it where '%{' instances are found and keep the delimiter
      .filter(chop => chop.startsWith("%{"))     // Filter the array so that only members starting with '%{' remain
      .map(chop =>                               // Create new array and loop over it
        chop.endsWith("}") ?                     // Check if member is already ending with '}'
        chop :                                   // When yes, keep it intact
        chop.substring(0, chop.indexOf("}") + 1) // When no, remove everything after '}'
      )

    Object.keys(attributes).forEach(() => {
      placeholders.forEach((placeholder) => {
        const attribute = placeholder.split("%{")[1].split("}")[0]
        const value = attributes[attribute];

        parsedTemplate = parsedTemplate.replace(placeholder, value)
      });
    });

    return parsedTemplate;
  }

  const initiateClickOnEnterPress = (element) => {
    element.addEventListener("keyup", (event) => {
      event.preventDefault();
      if (event.keyCode === 13) {
        element.click();
      }
    });
  }

  const hideVisually = function hideVisually(element) {
    element.classList.add("u-hiddenVisually");
  }

  const showVisually = (element) => {
    element.classList.remove("u-hiddenVisually");
  }

  const inputEvent = new Event('input', {
    bubbles: true,
    cancelable: true
  });

  const handleSuggestionClick = (selectedSuggestion, originalInput, inputForNew, monitoredInput, config, callback) => {
    const navigateOnClick = JSON.parse(config.navigateOnClick);
    const data = selectedSuggestion.dataset;

    selectedSuggestion.addEventListener("click", (event) => {
      event.preventDefault();
      if (config.creationPermitted && data.isCreateButton) {
        monitoredInput.value = data.value;
        monitoredInput.classList.add("Autocomplete-input--complete");
        monitoredInput.setCustomValidity("");
        inputForNew.value = data.value;
        inputForNew.dispatchEvent(inputEvent)
      } else if (navigateOnClick) {
        Turbo.visit(data.href, { action: 'replace' } );
      } else {
        monitoredInput.value = data.displayValue;
        monitoredInput.classList.add("Autocomplete-input--complete");
        monitoredInput.setCustomValidity("");
        originalInput.value = data.id;
        originalInput.dispatchEvent(inputEvent)
      }

      callback();
    });
  }

  const toggleUiHooksOnFocusEvents = (autocompleteInstance, suggestionsListElement) => {
    autocompleteInstance.addEventListener("focusin", () => {
      showVisually(suggestionsListElement);
    });

    autocompleteInstance.addEventListener("focusout", () => {
      hideVisually(suggestionsListElement);
    });
  }

  const displaySuggestions = (config, query, suggestionsListElement, fetchedSuggestions, callback) => {
    const itemClass = "Autocomplete-suggestionItem";
    const contentClass = "Autocomplete-suggestionItemContent";
    const title = config.suggestionItemTitleField;
    const titleClass = "Autocomplete-suggestionItemTitle"

    const description =
      config.suggestionItemDescriptionTemplate ?
      config.suggestionItemDescriptionTemplate :
      config.suggestionItemDescriptionField;

    const descriptionIsTemplated = !!config.suggestionItemDescriptionTemplate;
    const descriptionClass = "Autocomplete-suggestionItemDescription";

    fetchedSuggestions.forEach((fetchedSuggestion) => {
      const titleContent = fetchedSuggestion.attributes[title];
      let descriptionContent;
      if (description) {
        if (descriptionIsTemplated) {
          descriptionContent = parseTemplate(description, fetchedSuggestion.attributes)
        } else {
          descriptionContent = description;
        }
      }

      const suggestionItem = document.createElement("li");
      suggestionItem.classList = itemClass;
      suggestionItem.dataset.id = fetchedSuggestion.id;
      suggestionItem.dataset.displayValue = fetchedSuggestion.attributes[title];
      suggestionItem.dataset.href = fetchedSuggestion.links.self;

      suggestionItem.innerHTML = `
        <span class="${contentClass}" tabindex="0">
          ${ title ? `
            <span class="${titleClass}">
              ${titleContent}
            </span>
          `:""}

          ${ description ? `
            <span class="${descriptionClass}">
              ${descriptionContent}
            </span>
          `:""}
        </span>
      `;

      initiateClickOnEnterPress(suggestionItem);

      suggestionsListElement.appendChild(suggestionItem);

      callback(suggestionItem);
    });

    if (config.creationPermitted) {
      const createButton = document.createElement("li");
      createButton.dataset.isCreateButton = true;
      createButton.dataset.value = query;
      createButton.classList = itemClass;

      createButton.innerHTML = `
        <span class="${contentClass}" tabindex="0">
          + "<em>${query}</em>"
        </span>
      `;

      initiateClickOnEnterPress(createButton);

      suggestionsListElement.appendChild(createButton);

      callback(createButton);
    }
  }

  const fetchSuggestions = (query, url, callback) => {
    const path = url.split('?')[0];
    const params = new URLSearchParams(url.split('?')[1]);
    params.append('q', query);

    fetch(`${path}.json?${params}`, {
      method: "GET",
      headers: {
        'ContentType': 'application/json',
        'Accept': 'application/json'
      }
    })
    .then((response) => response.json())
    .then((results) => callback(results.data))
    .catch((error) => {
      /* eslint-disable no-console */
      console.warn("Something went wrong.", error);
      /* eslint-enable no-console */
    });
  }

  const clearPreviousSelection = (originalInput, inputForNew, monitoredInput, config) => {
    originalInput.value = null;
    originalInput.dispatchEvent(inputEvent);

    if (inputForNew) {
      inputForNew.value = null;
      inputForNew.dispatchEvent(inputEvent);
    }

    monitoredInput.classList.remove("Autocomplete-input--complete");

    if (monitoredInput.required) {
      monitoredInput.setCustomValidity(config.validationMessage);
    }
  }

  const clearPreviousSuggestions = (suggestionsListElement) => {
    suggestionsListElement.innerHTML = "";
  }

  const monitorInputChanges = (config, monitoredInput, originalInput, inputForNew, callback) => {
    // TODO:
    // navigateOnClick and corresponding logic present in this function does not
    // really belong here. A refactor is required
    const navigateOnClick = JSON.parse(config.navigateOnClick);

    let oldQuery = "";
    let timer;
    const delay = 300;

    monitoredInput.addEventListener("input", () => {
      if (navigateOnClick) {
        // If navigateOnClick is true, clicking a suggestion will never select an
        // item so we set originalInput.value directly on input instead
        originalInput.value = monitoredInput.value;
      }

      const newQuery = monitoredInput.value;

      clearTimeout(timer);
      timer = setTimeout(() => {
        if (newQuery === "") {
          clearPreviousSelection(originalInput, inputForNew, monitoredInput, config)
        }

        if (oldQuery !== newQuery) {
          oldQuery = newQuery;

          if (!navigateOnClick) {
            // If navigateOnClick is false, it means we are setting originalInput's
            // value on suggestion click and not via direct input, so each time
            // input is changed, previous selection should be cleared
            clearPreviousSelection(originalInput, inputForNew, monitoredInput, config)
          }

          callback(newQuery);
        }
      }, delay);
    });
  }

  const addComponentToDom = (config, autocompleteInstance, callback) => {
    const originalInput = autocompleteInstance.querySelector(".js-autocomplete-originalInputWrapper > input");

    const originalInputId = originalInput.id;
    const originalInputType = originalInput.type;

    const inputForNew = config.creationPermitted ? autocompleteInstance.querySelector(".js-autocomplete-inputForNew") : false

    const monitoredInput = document.createElement("input");

    originalInput.removeAttribute("id");
    originalInput.type = "hidden";

    monitoredInput.classList = originalInput.classList;
    monitoredInput.classList.add("Autocomplete-input");
    monitoredInput.type = originalInputType;
    monitoredInput.id = originalInputId;
    monitoredInput.placeholder = originalInput.placeholder;
    monitoredInput.autocomplete = "off";
    monitoredInput.required = originalInput.required;

    if (config.initialDisplayValue) {
      monitoredInput.value = config.initialDisplayValue;
    }

    if (monitoredInput.required) {
      monitoredInput.setCustomValidity(config.validationMessage);
    }

    originalInput.insertAdjacentElement("afterend", monitoredInput);

    const suggestionsListElement = document.createElement("ul");
    suggestionsListElement.classList = "Autocomplete-suggestionsList";

    autocompleteInstance.appendChild(suggestionsListElement);

    toggleUiHooksOnFocusEvents(autocompleteInstance, suggestionsListElement);

    callback(originalInput, inputForNew, monitoredInput, suggestionsListElement);
  }

  const initializeAutocompleteInstance = (autocompleteInstance) => {
    const config = autocompleteInstance.dataset;
    const { suggestionsUrl } = config;

    addComponentToDom(config, autocompleteInstance, (
      originalInput, inputForNew, monitoredInput, suggestionsListElement
    ) => {
      monitorInputChanges(config, monitoredInput, originalInput, inputForNew, (query) => {
        clearPreviousSuggestions(suggestionsListElement);

        if (query) {
          fetchSuggestions(query, suggestionsUrl, (fetchedSuggestions) => {
            displaySuggestions(config, query, suggestionsListElement, fetchedSuggestions, (selectedSuggestion) => {
              handleSuggestionClick(selectedSuggestion, originalInput, inputForNew, monitoredInput, config, () => {
                hideVisually(suggestionsListElement);
              });
            });
          });
        }
      });
    });
  };

  const autocompleteInstances = document.querySelectorAll(".js-autocomplete");
  if (autocompleteInstances.length > 0) {
    autocompleteInstances.forEach((autocompleteInstance) => {
      initializeAutocompleteInstance(autocompleteInstance);
    });
  } else {
    return false;
  }

  document.addEventListener("autocompleteAdded", e => {
    initializeAutocompleteInstance(e.target.querySelector('.js-autocomplete'));
  })

  return true;
});
