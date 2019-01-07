# require-j

Require-j is a Jade plugin that supports client-side Jade rendering, including inheritance, extends and include.


## About

When rendering Jade on the client, 
**require-j** adds the ability to use template inheritance constructs [extends](https://github.com/visionmedia/jade#template-inheritance) and [include](https://github.com/visionmedia/jade#includes), both of which need to read other templates files.  Let me explain why that is needed. 

When we build websites, it is natural to break the layout templates into separate files which get merged at render time. 
This works great during server rendering, but not during client rendering. 


When rendering templates on the server,  to load templates, jade depends on certain node modules (such as `path` and `fs`) to exist during runtime and uses `require` to access them. 

When rendering Jade on the client, this does not work.
The [problem](https://github.com/rocketlabsdev/require-jade/issues/11) is that node's `require` is replaced by RequireJS's `require` which has no notion of node modules.

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
