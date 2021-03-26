/* eslint-disable */

const eslint = require("gulp-eslint");
const gulp = require("gulp");
const plumber = require("gulp-plumber");
const stylelint = require("gulp-stylelint");
const svgSprite = require("gulp-svg-sprite");

const jsFiles = ["app/assets/javascripts/**/*.js"];
const cssFiles = ["app/assets/stylesheets/**/*.css"];

gulp.task("build:svg-sprite", () => {
  const config = {
    mode: {
      symbol: {
        render: {
          css: {
            template: "./app/assets/images/svg/.svg-sprite.css"
          }
        },
        prefix: ".Icon--%s",
        dimensions: "%s",
        example: true
      }
    }
  };

  return gulp
    .src("*.svg", { cwd: "./app/assets/images/svg/icons/" })
    .pipe(plumber())
    .pipe(svgSprite(config))
    .on("error", error => {
      console.log(error);
    })
    .pipe(gulp.dest("./app/assets/images/svg/sprite/"));
});

gulp.task("lint:js", () =>
  gulp
    .src(jsFiles)
    .pipe(eslint())
    .pipe(eslint.format())
    .pipe(eslint.failAfterError())
);

gulp.task("lint:css", () => {
  return gulp.src(cssFiles).pipe(
    stylelint({
      reporters: [{ formatter: "string", console: true }]
    })
  );
});

gulp.task("watch:lint:js", () => {
  gulp.watch(jsFiles, gulp.parallel("lint:js"));
});

gulp.task("watch:lint:css", () => {
  gulp.watch(cssFiles, gulp.parallel("lint:css"));
});

gulp.task(
  "default",
  gulp.parallel("lint:js", "lint:css", "watch:lint:js", "watch:lint:css")
);
