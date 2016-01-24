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
    describe "First, access to /#/", ->
      before ->
        browser.get "/#/"
      it "The address should be redirected to '/'", ->
        expect(browser.getCurrentUrl()).not.eventually.match /\/#\/$/
      describe "Then, clicking the button", ->
        before ->
          element(By.buttonText "Click").click()
        it "{{test.text}} should be \"Passed\"", ->
          expect(
            element(By.binding "test.text").getText()
          ).is.eventually.equal "Passed"
