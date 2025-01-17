# PostBee API

PostBee API is a dynamic job posting API designed to streamline job management for both employers and job seekers. This API provides functionalities for creating, managing, and applying for job postings while ensuring a smooth user experience.

[Deployed site](https://postbee-api.onrender.com)

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [System Requirements](#system-requirements)
- [Installation](#installation)
- [Usage](#usage)
- [API Endpoints](#api-endpoints)
- [Running Tests](#running-tests)
- [Contributing](#contributing)
- [License](#license)

## Features

- **User Authentication:** Secure sign-up, login, and logout functionalities to protect user accounts.
- **Job Posting:** Employers can easily create and manage job listings with essential details.
- **Responsive Design:** Built with modern practices to ensure compatibility across devices.
- **Intuitive UI:** Simplifies navigation and enhances user engagement.

## Getting Started

To get started with the PostBee API, follow the instructions below.

### System Requirements

- Ruby version: 2.7 or later
- Docker (if using Docker for deployment)
- MongoDB

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/Bluette1/postbee-api.git
   cd postbee-api
   ```

2. **Install dependencies:**

   ```bash
   bundle install
   ```

3. **Configure the database:**

   ```bash
   rails db:create
   rails db:migrate
   ```

## Usage

To start the server, run:

```bash
rails server
```

You can now access the API at `http://localhost:3000`.

## API Endpoints

- **POST /api/jobs** - Create a new job posting.
- **GET /api/jobs** - Retrieve all job postings.
- **GET /api/jobs/:id** - Retrieve a specific job posting by ID.
- **PUT /api/jobs/:id** - Update a specific job posting.
- **DELETE /api/jobs/:id** - Delete a specific job posting.

## Running Tests

To run the test suite, use:

```bash
rails test
```

```bash
bundle exec cucumber
```


## Configuring the Mailer

To set up the mailer in your Rails application, follow these steps:

1. **Set up Action Mailer**:
   Ensure you have Action Mailer configured in your `config/environments/development.rb` (or `production.rb` for production settings). Here’s a basic configuration:

   ```ruby
   # config/environments/development.rb
   config.action_mailer.delivery_method = :smtp
   config.action_mailer.smtp_settings = {
        address: 'smtp.example.com',
    port: 587,
    domain: ENV['MAIL_HOST'],
    user_name: ENV['SENDMAIL_USERNAME'],
    password: ENV['SENDMAIL_PASSWORD'],
    authentication: 'plain',
    enable_starttls_auto: true
   }
   ```

   Replace the placeholders with your SMTP server details.

2. **Set the Host for URL Generation**:
   In the same environment configuration file, set the default URL options:

   ```ruby
   config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
   ```

   Adjust the host and port as necessary for your environment.

## Running Sidekiq

Sidekiq is used for background job processing in your Rails application. To run Sidekiq, follow these steps:

1. **Install Sidekiq**:
   Ensure you have Sidekiq added to your Gemfile:

   ```ruby
   gem 'sidekiq'
   ```

   Run `bundle install` to install the gem.

2. **Configure Sidekiq**:
   Create a configuration file for Sidekiq if you haven't already. You can create `config/sidekiq.yml`:

   ```yaml
   :concurrency: 5
   :queues:
     - default
   ```

   Adjust the concurrency and queues as needed.

3. **Start Redis**:
   Sidekiq requires Redis to manage background jobs. Make sure you have Redis installed and running. You can start Redis with:

   ```bash
   redis-server
   ```

4. **Start Sidekiq**:
   In your terminal, navigate to your Rails application directory and run:

   ```bash
   bundle exec sidekiq
   ```

   This will start Sidekiq, and it will begin processing jobs in the background.

5. **Monitoring Sidekiq**:
   To monitor the Sidekiq dashboard, you can add a route in your `config/routes.rb`:

   ```ruby
   require 'sidekiq/web'
   mount Sidekiq::Web => '/sidekiq'
   ```

   You can access the dashboard by navigating to `http://localhost:3000/sidekiq` in your browser.


### Summary

These instructions should help users configure the mailer and run Sidekiq in your Rails application. Feel free to customize any parts of this text to better fit your project's needs! If you need any more additions or modifications, let me know!

## Contributing

We welcome contributions to improve PostBee! Please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -m 'Add new feature'`).
4. Push to the branch (`git push origin feature-branch`).
5. Create a pull request.

- [User Stories](https://www.notion.so/PostBee-API-User-Stories-149e6a4d98f280849601e17fcdfd7efc?pvs=4)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
