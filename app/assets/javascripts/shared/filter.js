import MultiSelect from '@dotburo/multi-select';

document.addEventListener("turbo:load", () => {
  const multiselects = document.querySelectorAll('.multiselect');

  multiselects.forEach(multiselect => {
    const items = JSON.parse(multiselect.dataset.items).map( item => ({ key: item[0], value: item[1] }));
    const multiSelectInput = multiselect.querySelector('input');
    const current = multiSelectInput.value.split(',')

    const multiSelectEl = new MultiSelect('.multiselect', {
      items,
      current: items.filter(item => current.includes(String(item.key))),
      placeholder: multiselect.dataset.placeholder,
      display: 'value'
    });

    multiSelectEl.on('change', () => {
      multiSelectInput.value = multiSelectEl.getCurrent().map( item => item.key);
    });

  });
});
