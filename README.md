# Mock Bypass Evidence for protractor

## What's this?
The evidence that protractor can't mock http backend

## The detail of the bug
Making angular web app, and adding route that path is "/" with `HTML5Mode = true`,
You can't mock backend with protractor for "/".

## How can I reproduce the bug?
1. Make angular app as usual, but enable HTML5Mode like this:
```javascript
angular.module("test", ["ngRoute", "test.resource"]).config([
  "$locationProvider", function(location) {
    location.html5Mode(true);
  }
]);
```
2. Make route that path is "/"
3. Make protractor spec file.

For details, please check ["Source Code"](src) and ["Test"](test).
