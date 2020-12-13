# README

This app reads the tracking status of packages and shares it in a rabbitmq queue for other app's consumption. Now is doing the tracking search against FedEx API.

* Ruby version 2.7.1

* Rails 6 api-only

* System dependencies:
  A rabbitmq message broker is needed. Can you use the cloudamqp.com freetier.

* Configuration:
  You need to set an .env file, rename the .envexample and change the connection information to you rabbitmq server:
  `CLOUDAMQP_URL="amqps://user:password@host/user"`

* Database creation:
Typical `rails db:create` and `rails db:seed` for load test data.

* How to run the test suite:
bundle exec rspec

* Services:
You can use the free tier of cloudamqp.com and avoid local rabbitmq instalation.

* How it works:
Controller -> For now, the controller commands the search and update of tracking numbers, you can call the update of tracking information in this way: `<URL_BASE>/packages/149331877648230/track`.
You can use the track numbers in the seed file for testing purposes. The information needs to be preloaded for now.
Job -> Execute the search in the API of the transportation provider. It does a retry on timeout cases. You can extend the Job Class and implement other provider integrations.
Publisher(event) -> Commands the interaction with rabbitmq. Puts the messages in the queue for later consumption.
