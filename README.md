# Rails 8 Framework
This is a simple Rails 8 framework that can be used to build a new Rails 8 application.

## Requirements
Make sure you have PostgreSQL and Ruby installed on your machine.

## Usage

### Install with CLI:
> (download the files and open terminal and cd into directory)
```cli
 ./generate.rb
```

<img src="/images/cli.png" style="width: 600px">

### Skip CLI:
```cli
 rails new your_app_name \
  -m https://raw.githubusercontent.com/aFightClub/Rails-Framework/main/template.rb \
  --database=postgresql
```

Run in the terminal to generate a new Rails 8 application based on this framework.

## What is it, again?

It will setup the dashboard, authentication with an account view and registration view. Uses TailwindCSS for styling and has a simple layout. Go from nothing to soemthing as fast as possible. The auth / application have two seperate layouts. There is an `application` folder for share partials for header, footer, etc.

- Dashboard
- Login
- Signup
- Password Reset
- Account

<img src="/images/login.png" style="width: 600px">

## Who is it for?

For a FightClub community for people who like to build stuff.

### Requirements:
- Rails 8
- Ruby
- PostgreSQL
- SQLite3 (for Solid Queue)

### Gem List:
- TailwindCSS
- Rack-CORS
- Ruby OpenAI
- Chartkick
- Groupdate
- Pagy
- SQLite3
- Meta Tags
- Faker

## Deployment:
- Kamal 2
- Docker

Made by aFightClub.app
