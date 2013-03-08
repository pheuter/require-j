# require-j

RequireJS Jade plugin that supports client-side Jade rendering, including template inheritance.

## About

**require-j** attempts to fill the gap left by porting jade over to the client, namely the ability to use template inheritance constructs such as [extends](https://github.com/visionmedia/jade#template-inheritance) and [include](https://github.com/visionmedia/jade#includes).

To load templates, jade depends on certain node modules (such as `path` and `fs`) to exist during runtime and uses `require` to access them. The [problem](https://github.com/rocketlabsdev/require-jade/issues/11) is that node's `require` is replaced by RequireJS's `require` which has no notion of node modules.

To address this issue, **require-j** overrides jade's default [parseInclude](https://github.com/visionmedia/jade/blob/master/jade.js#L3123-L3164) and [parseExtends](https://github.com/visionmedia/jade/blob/master/jade.js#L3062-L3085) functions with a variant that utilizes RequireJS APIs, such as [toUrl](http://requirejs.org/docs/plugins.html#apiload) and `fetchText`. *This is achieved without any modifications to the jade library.*

## Todo

* Refactor `load` to support dynamic loading from the browser

## Dependencies

* [Jade](https://github.com/visionmedia/jade)

## Setup

Initialize jade submodule

```sh
$ git submodule init
$ git submodule update
```

Install dependencies

```sh
$ npm install
```

## Build plugin and demo app

```sh
$ cake build
```

*Will create `lib/j.js` and `demo/main.out.js`*

## Usage

Check out the demo app in **demo/** for a sample app utilizing **require-j**