**Loyalty Reward App**

A Ruby on Rails application implementing a loyalty rewards program for customers. This app provides secure API endpoints to track user transactions, calculate loyalty points, and issue rewards based on spending rules.

---

## Prerequisites

Ensure you have the following installed on your machine:

* **Ruby** (version 3.0.2 recommended)
* **Rails** (version 7.x)
* **PostgreSQL** (database server)
* **Node.js** & **Yarn** (for Webpacker and frontend assets)
* **Git** (source control)

## Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/IliaZolas/loyalty-program.git
   cd loyalty-program
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

1. **Create and migrate the database**

   ```bash
   rails db:create
   rails db:migrate
   rails db:seed 
   ```

   Make sure to copy these values for your http request either via postman or curl

  ```
  Seeded Client: DemoClient (API key: some value)
  Seeded User: test@example.com (ID: some ID)
  ```

## Running the App Locally

  Start the Rails server:

  ```bash
  rails server
  ```

  Visit `http://localhost:3000` in your browser.

## API Endpoints

  All API routes are prefixed with `/api/v1` and require an `Authorization` header with the client API key.

## Running Tests

  This app uses RSpec for testing. Run the full test suite with:

  ```bash
  bundle exec rspec
  ```

## Development Notes

  * **Service Objects** are located in `app/services/`
  * **API Controllers** in `app/controllers/api/v1/`
  * **Models & Migrations** follow standard Rails conventions in `app/models/` and `db/migrate/`

## Postman or Curl

  If using Postman, use the structure and variables below. You can also download the Postman Collection from this repo and import it into your Postman app for quick configuration.
  
  See the postman folder at the root of the project directory to access the file.

### Postman

  ```bash
  base_url:   http://localhost:3000
  api_key: #copy after running seed, demo client api key
  user_id: #copy after running seed, likely value is 1
  ```

  POST Request - Transactions

  ```bash
  {{base_url}}/api/v1/users/{{user_id}}/transactions
  ```

  GET Request - Rewards

  ```bash
  {{base_url}}/api/v1/users/{{user_id}}/rewards
  ```

### Curl

  If using curl, use this structure.

  POST Request -  Transactions

  ```bash
  curl -i \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer PASTE-CLIENT-KEY-HERE" \
  -d '{"transaction":{"amount_cents":10000,"country_code":"US","occurred_at":"2025-07-26T00:00:00Z"}}' \
  http://localhost:3000/api/v1/users/1/transactions.json
  ```

  GET Request - Rewards

  ```bash
  curl -i \
  -H "Accept: application/json" \
  -H "Authorization: Bearer PASTE-CLIENT-KEY-HERE" \
  http://localhost:3000/api/v1/users/1/rewards.json
  ```

  Response structure should look something like this

  Transactions
  ```json
  {
      "points_awarded": 10,
      "total_points": 10,
      "dollars_spent": 100.0,
      "rewards": [
          {
              "type": "free_coffee",
              "reason": "Birthday Coffee",
              "issued_at": "2025-07-27T15:09:43.337Z"
          }
      ]
  }
  ```

  Rewards
  ```json
  [
      {
          "id": 1,
          "user_id": 1,
          "reward_type": "free_coffee",
          "issued_at": "2025-07-27T15:09:43.337Z",
          "created_at": "2025-07-27T15:09:43.349Z",
          "updated_at": "2025-07-27T15:09:43.349Z",
          "reason": "Birthday Coffee"
      }
  ]
  ```

## Notes

### Git Branch Naming Convention

  Projects are normally scoped in some sort of project management/ticketing tool like Linear, Jira or Notion. This allows for conventional commits which look something like this:

  ```bash
  branch
  ft/login‑form‑UI‑1234
  ```
  I normally follow this conventioin. For this project, I decided not to as I did not have a large volume of features to keep track of alongside a project management tool.

### Time Spent on Project

I spent a total of about 8 hours on this project. As Ruby on Rails has not been my primary some time, I needed to familiarisee myself with various Rails conventions.

### Conclusion

This app is intended for backend assessment. I expect the api to be tested via Curl or Postman. 

However, I have provided a basic frontend which allows the seeded user to login, simulate a purchase and receive their rewards. The frontend simply makes use of the views within the MVC pattern of Rails. 

For a more sophisticated frontend, I would have created a Next.js app that would make requests to the Rails app and display the responses.

Thank you for taking the time to evaluate this project!

All the best,
Ilia 🍻

