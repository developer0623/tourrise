function sortByDateAndTime(firstFlight, secondFlight) {
  return new Date(secondFlight.takeoffAt) - new Date(firstFlight.takeoffAt);
}

function updateFlightItem(flightForm, flightData) {
  const airlineCodeInput = flightForm.querySelector('input[id$="airline_code"]');
  const flightNumberInput = flightForm.querySelector('input[id$="flight_number"]');
  const arrivalAtInput = flightForm.querySelector('input[id$="arrival_at"]');
  const arrivalAirportInput = flightForm.querySelector('input[id$="arrival_airport"]');
  const departureAtInput = flightForm.querySelector('input[id$="departure_at"]');
  const departureAirportInput = flightForm.querySelector('input[id$="departure_airport"]');

  if (airlineCodeInput) airlineCodeInput.value = flightData.airlineCode;
  if (flightNumberInput) flightNumberInput.value = flightData.flightNumber;
  if (arrivalAtInput) arrivalAtInput.value = flightData.landingAt;
  if (arrivalAirportInput) arrivalAirportInput.value = flightData.landingAirportCode;
  if (departureAtInput) departureAtInput.value = flightData.takeoffAt;
  if (departureAirportInput) departureAirportInput.value = flightData.takeoffAirportCode;

  return true;
}

function updateFlights(container, template, flights) {
  const myContainer = container;
  myContainer.innerHTML = "";

  flights.forEach( (flight, index) => {
    const newNode = myContainer.insertBefore(
      template.content.firstElementChild.cloneNode(true),
      myContainer.firstChild
    );

    Array.from(newNode.querySelectorAll("label, select, input")).forEach(
      element => {
        const el = element;

        if (el.tagName === "LABEL") {
          const newVal = el.getAttribute("for").replace("_FLIGHT_ID_", `_${index}_`);
          el.setAttribute("for", newVal);
        } else {
          el.id = el.id.replace("_FLIGHT_ID_", `_${index}_`);
          el.name = el.name.replace("[FLIGHT_ID]", `[${index}]`);
        }
      }
    );

    updateFlightItem(newNode, flight);
  });
}

function parseBistro(match) {
  const takeoffAtDateAndTime = match[3].split(' ');
  const takeoffAtDate = takeoffAtDateAndTime[0];
  const takeoffAtTime = takeoffAtDateAndTime[1];

  const takeoffAtYear = takeoffAtDate.split('.')[2];
  const takeoffAtMonth = `0${takeoffAtDate.split('.')[1]}`.slice(-2);
  const takeoffAtDay = `0${takeoffAtDate.split('.')[0]}`.slice(-2);

  const landingAtDateAndTime = match[5].split(' ');
  const landingAtDate = landingAtDateAndTime[0];
  const landingAtTime = landingAtDateAndTime[1];

  const landingAtYear = landingAtDate.split('.')[2];
  const landingAtMonth = `0${landingAtDate.split('.')[1]}`.slice(-2);
  const landingAtDay = `0${landingAtDate.split('.')[0]}`.slice(-2);

  const data = {
    airlineCode: match[1],
    flightNumber: match[2],
    takeoffAt: `${takeoffAtYear}-${takeoffAtMonth}-${takeoffAtDay}T${takeoffAtTime}`,
    takeoffAirportCode: match[4],
    landingAt: `${landingAtYear}-${landingAtMonth}-${landingAtDay}T${landingAtTime}`,
    landingAirportCode: match[6],
  };

  return data;
}

function parseAmadeus(match) {
  const carrier = match[1];
  const flightNumber = match[2];
  const dayOffsetOperator = match[6].slice(4,5);
  const offsetDays = Number(match[6].slice(5));
  const now = new Date();

  const departureDate = (new Date(`${match[3].substr(0,2)  } ${  match[3].substr(2)  } ${  now.getFullYear()}`));

  if (departureDate < now) {
    departureDate.setFullYear(departureDate.getFullYear() + 1);
  }

  const arrivalDate = new Date(departureDate);

  if (dayOffsetOperator === '+' && !Number.isNaN(offsetDays)) {
    arrivalDate.setDate(departureDate.getDate() + offsetDays);
  }

  if (dayOffsetOperator === '-' && !Number.isNaN(offsetDays)) {
    arrivalDate.setDate(departureDate.getDate() - offsetDays);
  }

  const takeoffAtYear =  departureDate.getFullYear();
  const takeoffAtMonth = `0${departureDate.getMonth() + 1}`.slice(-2);
  const takeoffAtDay = `0${departureDate.getDate()}`.slice(-2);
  const takeoffAtHour = match[5].slice(0,2);
  const takeoffAtMinute =  match[5].slice(2,4);

  const landingAtYear =  arrivalDate.getFullYear();
  const landingAtMonth = `0${arrivalDate.getMonth() + 1}`.slice(-2);
  const landingAtDay = `0${arrivalDate.getDate()}`.slice(-2);
  const landingAtHour = match[6].slice(0,2);
  const landingAtMinute =  match[6].slice(2,4);

  const takeoffAt = `${takeoffAtYear}-${takeoffAtMonth}-${takeoffAtDay}T${takeoffAtHour}:${takeoffAtMinute}`;
  const landingAt = `${landingAtYear}-${landingAtMonth}-${landingAtDay}T${landingAtHour}:${landingAtMinute}`;

  return {
    airlineCode: carrier,
    flightNumber: flightNumber.replace(/\s/g, '0'),
    takeoffAt,
    takeoffAirportCode: match[4].slice(0,3),
    landingAt,
    landingAirportCode: match[4].slice(3),
  }
}

function parseManual(match)  {
  const airlineCode = match[1];
  const flightNumber = match[2];
  const takeoffAirportCode = match[3];
  const landingAirportCode = match[4];
  const dayOffsetOperator = match[8];
  const offsetDays = Number(match[9]);

  const takeoffAtYear =  match[5].slice(4);
  const takeoffAtMonth = `0${Number(match[5].slice(2,4))}`.slice(-2);
  const takeoffAtDay = `0${Number(match[5].slice(0,2))}`.slice(-2);
  const takeoffAtHour = match[6].slice(0,2);
  const takeoffAtMinute =  match[6].slice(2,4);

  let landingAtDay = Number(match[5].slice(0,2));

  if (dayOffsetOperator === '+' && !Number.isNaN(offsetDays)) {
    landingAtDay += offsetDays
  }

  if (dayOffsetOperator === '-' && !Number.isNaN(offsetDays)) {
    landingAtDay -= offsetDays
  }

  const landingAtYear =  match[5].slice(4);
  const landingAtMonth = `0${Number(match[5].slice(2,4))}`.slice(-2);
  landingAtDay = `0${landingAtDay}`.slice(-2);
  const landingAtHour = match[7].slice(0,2);
  const landingAtMinute =  match[7].slice(2,4);

  const takeoffAt = `${takeoffAtYear}-${takeoffAtMonth}-${takeoffAtDay}T${takeoffAtHour}:${takeoffAtMinute}`;
  const landingAt = `${landingAtYear}-${landingAtMonth}-${landingAtDay}T${landingAtHour}:${landingAtMinute}`;

  return {
    airlineCode,
    flightNumber,
    takeoffAt,
    takeoffAirportCode,
    landingAt,
    landingAirportCode
  }
}

function parsePNR(pnr) {
  const bistroRegex = /(\S{2,3})\s(\S{3,4})\s(\d{1,2}\.\d{1,2}\.\d{4}\s\d{1,2}:\d{2})\s(\w{3})\s{1,2}(\d{1,2}\.\d{1,2}\.\d{4}\s\d{1,2}:\d{2})\s(\w{3})\s(.*)$/gm;
  const amadeusRegex = /^\s{0,2}\d{1,2}\s{1,2}(\w{2})\s?(\w{3,4}).{3}(\d{2}\w{3}).{3}(\w{6}).*(\d{4})\s(\d{4}(?:\s{1,2}|[+-]\d)).*$/gm;
  const manualRegex = /^(\w{2})(\d{3,4})\s([A-Z]{3})\s([A-Z]{3})\s(\d{8})\s(\d{4})\s(\d{4})([+-]?)(\d?)$/gm;

  const parsedFlights = [];

  const pastedString = pnr.toUpperCase();

  const bistroMatches = [...pastedString.matchAll(bistroRegex)];
  const amadeusMatches = [...pastedString.matchAll(amadeusRegex)];
  const manualMatches = [...pastedString.matchAll(manualRegex)];

  if (bistroMatches.length >= 1) {
    bistroMatches.forEach( match => parsedFlights.push(parseBistro(match)) );
  }

  if (amadeusMatches.length >= 1) {
    amadeusMatches.forEach( match => parsedFlights.push(parseAmadeus(match)) );
  }

  if (manualMatches.length >= 1) {
    manualMatches.forEach( match => parsedFlights.push(parseManual(match)) );
  }

  return parsedFlights.sort(sortByDateAndTime);
}

document.addEventListener("turbo:load", () => {
  const bookingResourceEdit = document.querySelector(".js-BookingResourceEdit");

  if (bookingResourceEdit) {
    const flightTemplate = bookingResourceEdit.querySelector(".js-Flight-template");
    const flightsContainer = bookingResourceEdit.querySelector(".js-Flights-container");
    const pnrParserField = bookingResourceEdit.querySelector(".js-pnrParserField");

    if (pnrParserField) {
      pnrParserField.addEventListener('paste', event => {
        const pastedString = (event.clipboardData || window.clipboardData).getData('text');
        const parsedFlights = parsePNR(pastedString);
        updateFlights(flightsContainer, flightTemplate, parsedFlights)
      });

      pnrParserField.addEventListener('keyup', event => {
        const pastedString = event.target.value;
        const parsedFlights = parsePNR(pastedString);
        updateFlights(flightsContainer, flightTemplate, parsedFlights)
      });
    }
  }
});
