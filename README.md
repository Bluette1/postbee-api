# PostBee API

PostBee API is a dynamic job posting API designed to streamline job management for both employers and job seekers. This API provides functionalities for creating, managing, and applying for job postings while ensuring a smooth user experience.

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
