window.addEventListener('turbo:load', () => {
  const div = document.createElement("div");
  const divId = "iePartialSupportWarning";
  const divHeight = document.getElementById(divId).clientHeight;

  div.innerHTML = `
    This browser (Internet Explorer) doesn't support the whole feature set of
    our website. Please try another browser (f.e. Firefox, Google Chrome)
  `
  div.style.cssText = `
    width: 100%;
    position: fixed;
    top: 0;
    left: 0;
    text-align: center;
    padding: 1em 2em;
    background-color: #ecd8de;
    color: #c90040;
    border-bottom: 1px solid #c90040;
    font-style: italic;
  `
  div.id = divId;
  document.body.appendChild(div);

  document.body.style.cssText = `margin-top: ${divHeight + 50}px;`
});
