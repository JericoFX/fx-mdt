module.exports = {
  purge: {
    enabled: !process.env.ROLLUP_WATCH,
    content: ['./public/index.html', './src/**/*.svelte',"./src/**/*.ts"],
    variants: {
      width: ["responsive", "hover", "focus"]
  }
  },
  plugins: [
    require('daisyui'),
  ],
  future: {
    purgeLayersByDefault: true,
    removeDeprecatedGapUtilities: true,
  },
}