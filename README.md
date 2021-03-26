[![Maintainability](https://api.codeclimate.com/v1/badges/5fcbb9f47eae83a25643/maintainability)](https://codeclimate.com/repos/5efef54d7fc52a014d00a84c/maintainability)

# Setup

## Dependencies

- ruby 2.7.2
- yarn
- mariadb

## Docker
Build images: `docker-compose build`

Start containers: `docker-compose up -d`

The app will be available at `http://localhost:3000`

## Basics

Because of security reasons some config files are not checked into
version control but have some example data. You can use this data
for development and testing. However you can use your own configuration
as well.

If you want to use puma defaults run this command in your shell:

```
cp config/puma.example.rb config/puma.rb
cp config/database.example.yml config/database.yml
```

- Request the rails `master.key` from your Project Owner.

## Environment

`gem install bundler`

`bundle install`

`yarn install`

## Seting up DB

Database config file `config/database.yml` is included in the repository. In some
cases, it will be enough to get going, but you might also need to tweak some values
depending your machine setup. You can do that by adding environment variables to
`.env` file. Following variables will take effect:
`DATABASE_USERNAME`, `DATABASE_PASSWORD`, and `DATABASE_SOCKET`.

If you find this is not enough for your setup, feel free to add extra options to the `database.yml`. Make sure you make them optional, just like the 3 config options just discussed, so that other developers don't have to replicate your local settings.

Once `database.yml` is ready, the database is set up with standard Rails approach:

```shell
rails db:create db:migrate db:seed
```

Seeds are set up to clear the database before populating it, so if you only need to clear the data and re-seed, no need to drop the db. Instead, just run `rails db:seed`. Because of that, be extra careful if you ever need to run the seeds anywhere except your local environment (like one of the staging apps or a review app someone else is testing).

Important:

**NEVER attempt to seed a production database**

## Running project
For simplicity, you should make use of `Procfile.development` file, which will
start all the necessary processes for you.

If you use Foreman, run the following command:

```shell
foreman start -f Procfile.development
```

# Development

## Overview
* `master` should always be deployed to production and reflects the state of the production system
* `develop` should always be deployed to the staging system(s). Currently any commit to develop will auto deploy to hht-staging
* QA should be done before PR is merged into develop. If QA involves feedback from non-developers, Heroku's review apps must be used
* Once QA on staging is done yuou have to merge develop to master and promote the current state to the production systems
* No direct commits to master
* No direct commits to develop (there are exceptions, and you know them haha)
* Features/Bugfixes/Refactorings should be merged via Pull Requests with at least one review
* The preferred merge strategy from PR -> develop is `squash merge`
* The preferred merge strategy from develop -> master is `merge commit`

## Release steps
1. Pick a task to work on
2. Open a new branch
3. Open a PR
4. Get it reviewed
5. Merge into `develop` & deploy to staging
6. Merge into `master` & deploy to production


## Adding icons
### Building icons
Add the SVG file to `app/assets/images/svg/icons` and run:

```shell
gulp build:svg-sprite
```

This will generate a sprite for the svg file and update the sprites css
accordingly.

### Finding ready-made svg icons
Previous step assumes you already have the svg icon you want to build, but
sometimes you might not. One approach already used in this project is to grab
readily available icons from [Font-Awesome-SVG-PNG](https://github.com/encharm/Font-Awesome-SVG-PNG/tree/master/black/svg).
To do this:

1. Click on desired icon
2. Click on "Raw" link to view raw SVG code
3. Copy everything starting from line 2 (Do NOT copy `<?xml version="1.0" encoding="utf-8"?>`)
4. Create SVG file named `fa-YOUR-ICON.svg` and paste copied code in it

You can now build your icon according to previous step.

## Translating the app
We use [Tolk](https://github.com/tolk/tolk) as a web interface to translate the
app into supported languages.

The `de-RAW - German (default)` locale serves as our reference, meaning the only
files you should update directly (from your code editor) is `de-RAW.yml` or
another file ending with `.de-RAW.yml`, when appropriate.

While the other language files are also checked in the repository, you should
never update them from your code editor and you should use Tolk instead.

### Setup
Add `TRANSLATION_SERVER_URL` variable to `.env` and set its value to the
value of `DATABASE_URL` on protrainingtours-staging Heroku app. If you were
granted Heroku access, you can get it on Heroku dashboard or from terminal via
Heroku cli:

```shell
heroku config:get DATABASE_URL -a protrainingtours-staging
```
If you don't have access to Heroku, request the URL from your manager.

### Adding translations
1. Add new keys to `de-RAW` locale. This may show up in end users browser because we treat `de-RAW` as fallback. Also, this is what translators translate from. So please make sure your text is in German and makes enough sense (even if it's rather dry from stylistic point of view)
2. Run `bundle exec rails translations:sync` to push the new keys to Tolk database
3. Now you or the person who is supposed to provide the translation can translate the keys in our [Tolk](https://protrainingtours-staging.herokuapp.com/translations) instance.
4. Once the translation is done, pull it back from Tolk via `bundle exec rails translations:dump` command. This will update secondary locale files like `de.yml`, `en.yml`, `fr.yml` etc.
5. Commit the changes

**NOTE:** Steps 2-4 are only required for pull requests that deal with Frontoffice texts. In other cases, they are desired but optional.
