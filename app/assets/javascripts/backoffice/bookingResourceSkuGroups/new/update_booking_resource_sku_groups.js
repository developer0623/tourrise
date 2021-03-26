import { localizePrice } from '../../../shared/utils';

document.addEventListener("turbo:load", () => {
  const bookingResourceSkusSection = document.querySelector('.js-BookingResourceSkusSection');

  if (bookingResourceSkusSection) {
    const groupPrice       = document.querySelector(".js-groupPrice");
    const costCenter       = document.querySelector(".js-costCenter");
    const financialAccount = document.querySelector(".js-financialAccount");
    const checkboxes       = bookingResourceSkusSection.querySelectorAll(".js-groupMember");

    const updateGroupData = () => {
      const checkedBoxes = bookingResourceSkusSection.querySelectorAll("input:checked");

      let calculatedPrice = 0;
      let costCenterId;
      let financialAccountId;

      checkedBoxes.forEach(checkbox => {
        const checkboxCostCenterId = checkbox.dataset.costCenterId;
        const checkboxFinancialAccountId = checkbox.dataset.financialAccountId;

        calculatedPrice += parseFloat(checkbox.dataset.priceCents);

        if (!checkboxCostCenterId) {
          costCenterId = 0;
        }
        else if (checkboxCostCenterId === costCenterId) {
          costCenterId = checkboxCostCenterId;
        }
        else if (typeof costCenterId === "undefined") {
          costCenterId = checkboxCostCenterId;
        };

        if (!checkboxFinancialAccountId) {
          financialAccountId = 0;
        }
        else if (checkboxFinancialAccountId === financialAccountId) {
          financialAccountId = checkboxFinancialAccountId;
        }
        else if (typeof financialAccountId === "undefined") {
          financialAccountId = checkboxFinancialAccountId;
        };
      });

      groupPrice.value = localizePrice({ price: calculatedPrice / 100.00 });

      if (costCenterId) {
        costCenter.value = costCenterId;
      } else {
        costCenter.value = null;
      };

      if (financialAccountId) {
        financialAccount.value = financialAccountId;
      } else {
        financialAccount.value = "undefined";
      };
    };

    checkboxes.forEach(checkbox => {
      checkbox.addEventListener("click", () => {
        updateGroupData();
      });
    });

    groupPrice.addEventListener("blur", () => {
      groupPrice.value = localizePrice({ price: groupPrice.value });
    });
  }
});
