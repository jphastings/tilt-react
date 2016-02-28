# An example Sinatra App

This example app demonstrates how to use React Components as view templates in your sinatra app.

## Go go gadget example app

You'll need to download React in order to get this example to work. [Install NPM](https://docs.npmjs.com/getting-started/installing-node), install the npm dependencies, then run the app:

```bash
npm install
rackup
```
You should be set! Try visiting http://127.0.0.1:9292/?name=world

## Writing unit tests for your components

There are also simple tests demonstrating how to write unit tests for the HTML your components produce.

If you declare `type: :component` on the root `describe` block of your test suite, then that component is loaded, rendered with the `props` given, and the subject of the test becomes a Nokogiri HTML object, which allows easy assertion with `rspec-its` etc.
