# SnailTrain.com
> a Ruby on Rails 8 Framework generator with AI super powers.

Scaffold out your next SaaS application quickly. Use the CLI to generate a Ruby on Rails app with our framework that includes base UI screens, features and you can add your OpenAI API key to enable the AI super powers.

## What are the super powers?

When you are running the CLI you can use plain text to generate new scaffoldings. For example, you can say "I want a new model called 'User' with a 'name' and 'email' field" and it will generate the model, controller, views, and migrations for you and edit the appropriate files.

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
  -m https://raw.githubusercontent.com/aFightClub/SnailTrain/main/script/template.rb \
  --database=postgresql
```

Run in the terminal to generate a new Rails 8 application based on this framework.

## What is it, again?

It will setup the dashboard, authentication with an account view and registration view. Uses TailwindCSS for styling and has a simple layout. Go from nothing to something as fast as possible. The auth / application have two seperate layouts. There is an `application` folder for share partials for header, footer, etc.

- Dashboard
- Login
- Signup
- Password Reset
- Account

<img src="/images/login.png" style="width: 600px">

## Who is it for?

For a FightClub community for people who like to build stuff.

### Requirements
- Rails 8
- Ruby
- PostgreSQL
- SQLite3 (for Solid Queue)
- Git

### Bundle
- TailwindCSS
- Rack-CORS
- Ruby OpenAI
- Chartkick
- Groupdate
- Pagy
- SQLite3
- Meta Tags
- Faker

## Deployment
- Kamal 2
- Docker

Thank you for checking this out. Made to make our MVP prototypes faster and easier to build.
