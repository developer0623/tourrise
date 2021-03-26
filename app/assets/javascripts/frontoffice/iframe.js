import ResizeObserver from "resize-observer-polyfill";

window.parent.postMessage(document.body.offsetHeight, "*");

window.addEventListener("load", () => {
  window.parent.postMessage(document.body.offsetHeight, "*");
});

const ro = new ResizeObserver(() => {
  window.parent.postMessage(document.body.offsetHeight, "*");
});

ro.observe(document.body);
