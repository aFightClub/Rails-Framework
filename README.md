# SnailTrain.com
> a Ruby on Rails 8 Framework Generator with AI super powers.

Use the CLI to generate a Ruby on Rails app with our framework that includes base UI screens, MVP invite code and you can add your OpenAI API key to enable the AI super powers.

## What are the super powers?

When you connect with OpenAI API key you can use model `gpt-4o-2024-08-06` to generate the starting scaffolding for your app and it will run the migrations for you.

## What makes us different?

We start all apps without anything fancy (like Stripe, etc) and we have a built-in `Invite Code` which you can set in the generator. This allows you to build your MVP, invite your audience with invite code to start validating your app idea!

## Requirements

Make sure you have PostgreSQL and Ruby installed on your machine.

## Usage

### Install with Command Line Interface (CLI)
> (download the files and open terminal and cd into directory)
```cli
 ./generate.rb
```

<img src="/images/cli.png" style="width: 600px">

### Skip CLI & use base framework:
```cli
 rails new your_app_name \
  -m https://raw.githubusercontent.com/aFightClub/SnailTrain/main/script/build.rb \
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

This is made for small community of creators known as FightClub. We are a group of developers, designers, and entrepreneurs who are building MVPs and startups..

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

## Looking for more power?

We recommend BulletTrain for a more robust and scalable solution.
