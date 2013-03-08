({
  baseUrl: ".",
  name: "almond",
  include: ['main'],
  insertRequire: ['main'],
  out: "main.out.js",
  wrap: true,
  optimize: "none",
  paths: {
    jade: "../lib/jade/jade",
    j: "../lib/j"
  },
  stubModules: [
    "j"
  ],
  shim: {
    jade: {
      exports: "window.jade"
    }
  }
})