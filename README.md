# RideBoard.app

![Tests](https://github.com/AlexanderOtavka/ride-board/workflows/Tests/badge.svg)
![Linting](https://github.com/AlexanderOtavka/ride-board/workflows/Linting/badge.svg)
![Uptime Robot ratio (30 days)](https://img.shields.io/uptimerobot/ratio/m784075821-17bbb702b73c8668f358cb12)

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

If you want to get a shell in side the container when the server is *not* running, you can run `docker-compose run web bash`.
This will spin up a new instance and give you a shell inside of it.
Note that if you have a `docker-compose run` instance and a `docker-compose up` instance running at the same time both may work, but weird problems are likely to appear.

To stop all docker processes for this project, you can run `docker-compose stop` in any shell in a project folder.

## Running Tests

To just run all the tests once, run `docker-compose run web rails test`.

If you want tests to automatically rerun when you change files, run
`docker-compose run web bundle exec guard`. Guard will only run certain
tests when relevant files change. To run all tests, just hit enter in the
guard interactive console when you see the `>` prompt.

## Linting

This project uses [rubocop](https://www.rubocop.org/en/stable/) to lint ruby code.
To run ruby linting, call `docker-compose run web bin/lint.sh --ruby`.
Linting gets automatically run in on all pull requests against master, and github will complain if it does not pass.
The rules for rubocop can be found in [.rubocop.yml](.rubocop.yml).

## Deploying

This project is deployed on heroku, and available at https://rideboard.app.
The master branch is automatically deployed to a staging version of the app
at https://ride-board-staging.herokuapp.com/ by CI. Promotion from staging to
production is done manually.
