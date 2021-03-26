window.Honeybadger = require("honeybadger-js");

window.Honeybadger.configure({
  apiKey: process.env.HONEYBADGER_API_KEY,
  environment: process.env.NODE_ENV || 'development',
  revision: process.env.GIT_COMMIT || 'master',
});
