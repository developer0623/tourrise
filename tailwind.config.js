module.exports = {
  purge: [
    './app/**/*.html.erb',
    './app/**/*.rb',
    './app/**/*.js',
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}
