# RideBoard.app

> Ride sharing for Grinnell students

## Setting Local Environment Variables

There are some secrets or local defaults you may wish to override in your
environment without committing them to git. Copy `.env.local.example` to
`.env.local` and modify it to fit your needs.

## Starting the Dev Server

This project uses [Docker](https://www.docker.com/products/docker-desktop),
so you will need to install that. Configure the database by running
`docker-compose run web rails db:setup`. Then just run `docker-compose up`
from the project root to start the server at http://localhost:3000.

## Doing Things on the Container

There are a number of commands you may want to run inside the container, such
as `rails generate` or `rails console`. To get a shell inside the container,
just run `docker-compose exec web bash` once the server is running. This will
attach to the same container that the server is using and allow you to run
whatever commands you want.

## Running Tests

To just run all the tests once, run `docker-compose exec web rails test`.

If you want tests to automatically rerun when you change files, run
`docker-compose exec web bundle exec guard`. Guard will only run certain
tests when relevant files change. To run all tests, just hit enter in the
guard interactive console when you see the `>` prompt.

## Deploying

This project is deployed on heroku, and available at https://rideboard.app.
The master branch is automatically deployed to a staging version of the app
at https://ride-board-staging.herokuapp.com/ by CI. Promotion from staging to
production is done manually.
