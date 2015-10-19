chai = require "chai"
chai.use require "chai-as-promised"
expect = chai.expect

describe "Protractor mock bypass test", ->
  after ->
    browser.clearMockModules()
  describe "Mocking E2E mock", ->
    before ->
      browser.addMockModule "backend", ->
        angular.module("backend", ["ngMockE2E"]).run [
          "$httpBackend"
          (backend) ->
            backend.whenGET("/test").respond 200, (
              "text": "Passed"
            )
        ]
    describe "Then, accessing /#/", ->
      before ->
        browser.get "/#/"
      describe "Clicking the button", ->
        before ->
          element(By.buttonText "Click").click()
        it "{{test.text}} should be \"Passed\"", ->
          expect(
            element(By.binding "test.text").getText()
          ).is.eventually.equal "Passed"
