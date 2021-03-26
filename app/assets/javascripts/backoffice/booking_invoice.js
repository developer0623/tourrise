import { localizePrice } from '../shared/utils';

document.addEventListener("turbo:load", () => {
  if (document.querySelector(".js-paymentSection")) {
    const partialPaymentForm = document.querySelector(".js-partialPaymentForm");
    const finalPaymentForm = document.querySelector(".js-finalPaymentForm");

    const hide = (element) => {
      const el = element;

      el.style.display = "none";
    }

    const show = (element) => {
      const el = element;

      el.style.display = "";
    }

    if (partialPaymentForm) {
      const partialPriceEl = document.querySelector(".js-partialPrice");
      const finalPriceEl = document.querySelector(".js-finalPrice");
      const removePaymentButton = document.querySelector(".js-removePaymentButton")
      const addPaymentButton = document.querySelector(".js-addPaymentButton")
      const { locale, totalPrice, partialPrice } = partialPriceEl.dataset;
      const { finalPrice } = finalPriceEl.dataset;

      hide(addPaymentButton);

      const adjustFormat = (partialPriceValue, finalPriceValue) => {
        partialPriceEl.value = localizePrice({ price: partialPriceValue, locale });
        finalPriceEl.value = localizePrice({ price: finalPriceValue, locale });
      };

      const updateFinalPrice = (changedPriceValue) => {
        let calculatedFinalPrice;
        let priceValue = changedPriceValue;

        if (priceValue === "") {
          priceValue = 0;
        }

        calculatedFinalPrice = (totalPrice / 100 - parseFloat(priceValue));

        if (calculatedFinalPrice < 0) {
          priceValue = totalPrice / 100;
          calculatedFinalPrice = 0;
        }

        adjustFormat(priceValue, calculatedFinalPrice);
      };

      const updatePartialPrice = (changedPriceValue) => {
        let calculatedPartialPrice;
        let priceValue = changedPriceValue;

        if (priceValue === "") {
          priceValue = 0;
        }

        calculatedPartialPrice = (totalPrice / 100 - parseFloat(priceValue));

        if (calculatedPartialPrice < 0) {
          priceValue = totalPrice / 100;
          calculatedPartialPrice = 0;
        }

        adjustFormat(calculatedPartialPrice, priceValue);

      };
      const togglePayment = () => {
        const finalPaymentContainer = finalPaymentForm;

        if (finalPaymentContainer.style.display === "none") {
          finalPaymentContainer.style.display = "block";
          hide(addPaymentButton);
          partialPriceEl.readOnly = false;
          show(removePaymentButton);
        } else {
          [finalPaymentContainer, removePaymentButton].forEach((el) => { hide(el); });
          partialPriceEl.readOnly = true;
          show(addPaymentButton);
        }
      }

      removePaymentButton.addEventListener("click", e => {
        e.preventDefault();

        togglePayment();

        adjustFormat(totalPrice / 100, 0);
      })

      addPaymentButton.addEventListener("click", e => {
        e.preventDefault();

        togglePayment();

        adjustFormat(partialPrice / 100, finalPrice / 100);
      })

      partialPriceEl.addEventListener("blur", (e) => {
        updateFinalPrice(e.target.value);
      });

      finalPriceEl.addEventListener("blur", (e) => {
        updatePartialPrice(e.target.value);
      });
    };
  };
});
