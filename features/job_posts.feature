Feature: Job Posts
  As an API client
  I want to manage job posts
  So that I can maintain job listings

  Scenario: Creating a job post
    Given I send a POST request to "/job_posts" with the following data:
      """
      {
        "job_post": {
          "title": "Ruby Developer",
          "company_title": "Tech Corp",
          "location": "Remote",
          "time": "Full-time",
          "link": "https://example.com/jobs/1"
        }
      }
      """
    Then the response status should be 201
    And the response body should contain "Ruby Developer"