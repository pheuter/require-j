({
  baseUrl: ".",
  name: "main",
  out: "main.out.js",
  optimize: "none",
  paths: {
    jade: "../lib/jade/jade",
    j: "../lib/j"
  },
  stubModules: [
    "j",
    "jade" // Would eventually not be stubbed out, to provide helper functions
  ],
  shim: {
    jade: {
      exports: "window.jade"
    }
  }
})