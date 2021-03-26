import { German } from "flatpickr/dist/l10n/de";
import { French } from "flatpickr/dist/l10n/fr";

function isDateSupported() {
  const input = document.createElement("input");
  const value = "a";
  input.setAttribute("type", "date");
  input.setAttribute("value", value);
  return input.value !== value;
}

function isDateTimeLocalSupported() {
  const input = document.createElement("input");
  const value = "a";
  input.setAttribute("type", "datetime-local");
  input.setAttribute("value", value);
  return input.value !== value;
}

function getPreferredLanguage() {
  let language = "en";
  language = window.navigator.userLanguage || window.navigator.language;
  return language;
}

function initializeFlatpickr() {
  let locale;

  switch (getPreferredLanguage()) {
    case "de":
      locale = German;
      break;
    case "fr":
      locale = French;
      break;
    default:
      locale = null;
      break;
  }

  if (!isDateSupported()) {
    import("flatpickr").then(flatpickr => {
      flatpickr.default(document.querySelectorAll("input[type='date']"), { locale });
    });
  }

  if (!isDateTimeLocalSupported()) {
    import("flatpickr").then(flatpickr => {
      flatpickr.default(document.querySelectorAll("input[type='datetime-local']"), { locale, enableTime: true, dateFormat: 'Y-m-dTH:i', time_24hr: true });
    });
  }
}

document.addEventListener("turbo:load", () => {
  initializeFlatpickr();
});

export default initializeFlatpickr;
