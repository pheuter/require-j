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
    j: "../lib/j",
    runtime: "../lib/jade/runtime"
  },
  stubModules: [
    "j"
  ],
  shim: {
    jade: {
      exports: "window.jade"
    },
    runtime: {
      exports: "jade"
    }
  }
})
