const postcssImport = require("postcss-import");
const postcssFlexbugsFixes = require("postcss-flexbugs-fixes");
const postcssPresetEnv = require("postcss-preset-env");
const tailwindcss = require("tailwindcss");
const autoprefixer = require("autoprefixer");

module.exports = {
  plugins: [
    tailwindcss,
    autoprefixer,
    postcssImport,
    postcssFlexbugsFixes,
    postcssPresetEnv({
      autoprefixer: {
        flexbox: "no-2009"
      },
      stage: 3
    })
  ]
};
