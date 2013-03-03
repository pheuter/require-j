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
    "jade"
  ],
  shim: {
    jade: {
      exports: "Jade"
    }
  }
})