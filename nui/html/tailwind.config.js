module.exports = {
  content: ['./public/index.html', './src/**/*.svelte'],
  purge: {
    content: ['./public/index.html', './src/**/*.svelte'],
  },
  theme: {
    extend: {},
  },
  plugins: [
    require('daisyui'),
  ],
}