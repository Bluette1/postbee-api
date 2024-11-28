Feature: User Management API

  Scenario: User creates an account
    Given I send a POST request to "/users" with the following data:
      """
      {
        "user": {
          "email": "christell.denna@gmail.com",
          "password": "yourpassword123&",
          "password_confirmation": "yourpassword123&"
        }
      }
      """
    Then the response status should be 201
    And the response body should contain "christell.denna@gmail.com"