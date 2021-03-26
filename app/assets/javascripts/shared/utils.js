const refreshIcons = (container) => {
  container.querySelectorAll('use').forEach(use => {
    const useHref = use.getAttribute("xlink:href")
    use.setAttributeNS("http://www.w3.org/1999/xlink", "xlink:href", "")
    use.setAttributeNS("http://www.w3.org/1999/xlink", "xlink:href", useHref)
  })
}

const localizePrice = ({ price, locale = "de", precision = 2 }) => {
  let localizedPrice = parseFloat(price).toFixed(precision);

  if (locale === "de") {
    localizedPrice = localizedPrice.replace('.', ',');
  }

  return localizedPrice
}

export {
  refreshIcons,
  localizePrice
}
