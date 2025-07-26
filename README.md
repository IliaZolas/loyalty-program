**Ramen-Crazy, Loyalty Reward App**

A Ruby on Rails application implementing a loyalty rewards program for customers of "Ramen-Crazy". This app provides secure API endpoints to track user transactions, calculate loyalty points, and issue rewards based on spending rules.

---

## Prerequisites

Ensure you have the following installed on your machine:

* **Ruby** (version 3.0.2 recommended)
* **Rails** (version 7.x)
* **PostgreSQL** (database server)
* **Node.js** & **Yarn** (for Webpacker and frontend assets)
* **Git** (source control)

---

## Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/<your-username>/ramen-crazy.git
   cd ramen-crazy
   ```

2. **Install Ruby gems**

   ```bash
   bundle install
   ```

3. **Install JavaScript packages**

   ```bash
   yarn install --check-files
   ```

## Database Setup

4. **Create and migrate the database**

   ```bash
   rails db:create
   rails db:migrate
   ```

## Running the App Locally

Start the Rails server:

```bash
rails server
```

Visit `http://localhost:3000` in your browser.

---

## API Endpoints

All API routes are prefixed with `/api/v1` and require an `Authorization` header with the client API key.

* **Create Transaction**

  ```http
  POST /api/v1/users/:user_id/transactions
  Authorization: Bearer <CLIENT_API_KEY>
  Content-Type: application/json

  {
    "transaction": {
      "amount_cents": 15000,
      "country_code": "US",
      "occurred_at": "2025-07-26T12:34:56Z"
    }
  }
  ```

* **List Rewards**

  ```http
  GET /api/v1/users/:user_id/rewards
  Authorization: Bearer <CLIENT_API_KEY>
  ```

---

## Running Tests

This app uses RSpec for testing. Run the full test suite with:

```bash
bundle exec rspec
```

---

## Development Notes

* **Service Objects** are located in `app/services/`
* **API Controllers** in `app/controllers/api/v1/`
* **Models & Migrations** follow standard Rails conventions in `app/models/` and `db/migrate/`

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
