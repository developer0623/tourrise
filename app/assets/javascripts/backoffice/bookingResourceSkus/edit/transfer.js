import axios from 'axios';

const getTwoDigits = (value) => value < 10 ? `0${value}` : value;

const formatDate = (date) => {
  const day = getTwoDigits(date.getDate());
  const month = getTwoDigits(date.getMonth() + 1); // add 1 since getMonth returns 0-11 for the months
  const year = date.getFullYear();

  return `${year}-${month}-${day}`;
}

const formatTime = (date) => {
  const hours = getTwoDigits(date.getUTCHours());
  const mins = getTwoDigits(date.getUTCMinutes());

  return `${hours}:${mins}`;
}

function updateTransferFields(attributes) {
  const startsOnInput = document.querySelector(".js-InputElement--starts_on");
  const startTimeInput = document.querySelector(".js-InputElement--start_time");
  const pickupLocation = document.querySelector(".js-InputElement--pickup_location");
  const dropoffLocation = document.querySelector(".js-InputElement--dropoff_location");
  const reference = document.querySelector(".js-InputElement--reference");

  startsOnInput.value = attributes.startson;
  startTimeInput.value = attributes.starttime;
  pickupLocation.value = attributes.pickuplocation || '';
  dropoffLocation.value = attributes.dropofflocation || '';
  reference.value = attributes.reference;
}

function arrivalAsOption(attributes) {
  const arrivalAt = new Date(attributes.arrival_at);

  return {
    reference: attributes.display_flight,
    pickupLocation: attributes.arrival_airport,
    dropoffLocation: '',
    startTime: formatTime(arrivalAt),
    startsOn: formatDate(arrivalAt)
  }
}

function departureAsOption(attributes) {
  const departureAt = new Date(attributes.departure_at);

  return {
    reference: attributes.display_flight,
    pickupLocation: '',
    dropoffLocation: attributes.departure_airport,
    startTime: formatTime(departureAt),
    startsOn: formatDate(departureAt)
  }
}

function handleClick(event) {
  event.preventDefault();
  updateTransferFields({ ...event.target.closest('.js-Transfer-FlightOption').dataset});
}

function renderOption(option) {
  const element = document.createElement('div');

  element.addEventListener('click', event => handleClick(event));
  element.classList = 'js-Transfer-FlightOption';

  Object.keys(option).forEach(key => {
    element.setAttribute(`data-${key}`, option[key]);
  });

  const template = document.querySelector(".js-Transfer-template");
  const newNode = template.content.firstElementChild.cloneNode(true)
  element.appendChild(newNode);

  Object.keys(option).forEach(key => {
    const span = element.querySelector(`.js-Transfer-${key}`);

    if (option[key].length > 1) {
      span.innerHTML += option[key];
    } else {
      span.remove()
    }
  });

  return element
}

function renderOptions(attributes) {
  const options = [
    departureAsOption(attributes),
    arrivalAsOption(attributes)
  ]

  return options.map(option => renderOption(option));
}

async function updateFlight(id, flightsEl) {
  if (id) {
    const response = await axios.get(`/api/flights/${id}`);
    const json = await response.data;
    const {attributes} = json.data;

    renderOptions(attributes).forEach(option => flightsEl.appendChild(option));
  }
}

document.addEventListener("turbo:load", () => {
  if (document.querySelector(".js-Transfer-FlightReferenceSelect")) {
    const flightIdInput = document.querySelector(".js-SelectedFlightId");
    const flightsEl = document.querySelector('.js-Transfer-Flights');

    flightIdInput.addEventListener("input", event => {
      flightsEl.innerHTML = '';
      updateFlight(event.target.value, flightsEl);
    });
  }
});
