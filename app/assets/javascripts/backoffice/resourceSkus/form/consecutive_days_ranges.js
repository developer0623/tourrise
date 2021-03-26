function checkEmptyMessage () {
  const consecutiveDaysNodeList =document.querySelectorAll('.js-consecutiveDaysContainer .js-newConsecutiveDaysRange');
  const consecutiveDays = Array.from(consecutiveDaysNodeList).filter((el) => !el.hidden)
  const emptyMessage = document.querySelector('.emptyRangesMessage');

  if (consecutiveDays.length > 0) {
    emptyMessage.hidden = true;
  } else {
    emptyMessage.hidden = false;
  }
}

function addConsecutiveDaysRange () {
  const container = document.querySelector(".js-consecutiveDaysSection .js-consecutiveDaysContainer")
  const template = document.querySelector(".js-newConsecutiveDaysRangeTemplate");

  const newNode = container.insertBefore(
    template.content.firstElementChild.cloneNode(true),
    container.lastChild
  );
  const newIndex =
    document.querySelectorAll(".js-consecutiveDaysContainer .js-newConsecutiveDaysRange").length - 1;

  Array.from(newNode.querySelectorAll("label, input, select")).forEach(element => {
    const el = element;

    if (el.tagName === "LABEL") {
      const newVal = el.getAttribute("for").replace("_ID_", `_${newIndex}_`);
      el.setAttribute("for", newVal);
    } else {
      el.id = el.id.replace("_ID_", `_${newIndex}_`);
      el.name = el.name.replace("[ID]", `[${newIndex}]`);
    }
  });

  checkEmptyMessage();
}

function removeConsecutiveDaysRange(clickedElement) {
  const container = clickedElement.closest(".js-newConsecutiveDaysRange");

  container.querySelector(".RemoveRange").value = true;

  container.hidden = true

  checkEmptyMessage();
}

document.addEventListener("turbo:load", () => {
  const form = document.querySelector(".js-newConsecutiveDaysForm");

  if (form) {
    checkEmptyMessage();

    form.addEventListener("click", e => {
      const clickedElement = e.target;
      const button = clickedElement.closest('button')

      if (clickedElement.classList.contains('js-newConsecutiveDaysRangeButton')) {
        e.preventDefault();

        addConsecutiveDaysRange();
      }

      if (button && button.classList.contains('js-removeConsecutiveDaysRangeButton')) {
        e.preventDefault();

        removeConsecutiveDaysRange(button);
      }
    });
  }
});
