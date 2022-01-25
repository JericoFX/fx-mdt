const purgecss = require('@fullhuman/postcss-purgecss')

module.exports = {
  plugins: [
    purgecss({
      content: ['./src/**/*.svelte'],
      safelist: ['invisibleClass', /svelte/]
    }),
  ],

}