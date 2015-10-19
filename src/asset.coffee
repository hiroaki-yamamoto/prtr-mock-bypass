angular.module("test.resource", [
  "ngResource"
]).factory "Test", [
  "$resource",
  (resource) -> resource "/test"
]

angular.module("test", [
  "ngRoute"
  "test.resource"
]).config([
  "$locationProvider"
  "$routeProvider"
  (location, route) ->
    location.html5Mode true
    route.when "/", (
      "template":
        """
        <button data-ng-click=\"test.$get()\">Click</button>
        <p>{{test.text}}</p>
        """
      "controller": "testController"
    )
]).controller "testController", [
  "$scope"
  "Test"
  (scope, Test) ->
    scope.test = new Test();
]
