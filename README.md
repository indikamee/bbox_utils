# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies
    - `ruby 2.7.1`
    - `postgres`

* Configuration

    - `bundle install`
    - Export environement variables. (obtain from developer) 
        - `source ./.env.sh`

* Database creation

    - `rake db:create`

* Database initialization
    ```
    rake db:create
    rake db:migrate
    rake db:seed
    ```

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)
    - `bin/rails server`

* Deployment instructions
    - `git push heroku master`
* Functionality
    - Create event and its tickets in different categories
    - Manage details of selling agents (committee members)
    - Allocate tickets to committee members
    - Email tickts to buyer who can view tickets online.
    - Keep track of ticket sales, payment received status
    - Mark attendance at reception (TODO:: QR code)
    - Manage table allocations

User Roles
- Agent:
    - Can edit, bulk_edit tickets for asigned to them
    - bulk edit only available if event is open