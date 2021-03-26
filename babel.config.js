const babelPresetEnv = require("@babel/preset-env");
const babelPolyfill = require("@babel/polyfill");
const babelPluginMacros = require("babel-plugin-macros");
const babelPluginSyntaxDynamicImport = require("@babel/plugin-syntax-dynamic-import");
const babelPluginDynamicImportNode = require("babel-plugin-dynamic-import-node");
const babelPluginTransformDestructuring = require("@babel/plugin-transform-destructuring");
const babelPluginProposalClassProperties = require("@babel/plugin-proposal-class-properties");
const babelPluginProposalObjectRestSpread = require("@babel/plugin-proposal-object-rest-spread");
const babelPluginTransformRuntime = require("@babel/plugin-transform-runtime");
const babelPluginTransformGenerator = require("@babel/plugin-transform-regenerator");

module.exports = api => {
  const validEnv = ["development", "test", "production"];
  const currentEnv = api.env();
  const isDevelopmentEnv = api.env("development");
  const isProductionEnv = api.env("production");
  const isTestEnv = api.env("test");

  if (!validEnv.includes(currentEnv)) {
    throw new Error(
      "Please specify a valid `NODE_ENV` or " +
        '`BABEL_ENV` environment variables. Valid values are "development", ' +
        '"test", and "production". Instead, received: ' +
        JSON.stringify(currentEnv) +
        "."
    );
  }

  return {
    presets: [
      isTestEnv && [
        babelPresetEnv.default,
        {
          targets: {
            node: "current"
          }
        }
      ],
      (isProductionEnv || isDevelopmentEnv) && [
        babelPresetEnv.default,
        {
          forceAllTransforms: true,
          useBuiltIns: "entry",
          corejs: 3,
          modules: false,
          exclude: ["transform-typeof-symbol"]
        }
      ]
    ].filter(Boolean),
    plugins: [
      babelPluginMacros,
      babelPluginSyntaxDynamicImport.default,
      isTestEnv && babelPluginDynamicImportNode,
      babelPluginTransformDestructuring.default,
      [
        babelPluginProposalClassProperties.default,
        {
          loose: true
        }
      ],
      [
        babelPluginProposalObjectRestSpread.default,
        {
          useBuiltIns: true
        }
      ],
      [
        babelPluginTransformRuntime.default,
        {
          helpers: false,
          regenerator: true,
          corejs: false
        }
      ],
      [
        babelPluginTransformGenerator.default,
        {
          async: false
        }
      ]
    ].filter(Boolean)
  };
};
