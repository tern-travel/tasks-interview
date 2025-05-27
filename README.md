# README

This application is intended to serve as the starting point for a basic
pair programming interview.

## Setup

### PostgreSQL

We use PostgreSQL as our primary persistence store. On Mac OS, use [Homebrew](https://brew.sh)
to install the latest PostgreSQL version.

```
brew install postgresql@17
brew services start postgresql@17
```

### Ruby Version & Gems

We use a `.ruby-version` and `.ruby-gemset` file to indicate to your local
Ruby version manager the correct version of Ruby to use. Refer to those files
if you're manually managing your Ruby installation.

To install Rubygem dependencies, use Bundler:

```
bundle install
```

### Bootstrapping the Database

Refer to the `config/database.yml` file for details on the local database name
and connection information.

To get your local database setup, use the built-in Rails database management
commands:

```
bin/rails db:create db:migrate db:seed
```

This will seed the database with some initial data, including several users
you can use to log in.

### Local Development

Since we use the `tailwindcss-rails` gem to pull in the [Tailwind CSS library](https://tailwindcss.com),
the local development environment requires two separate process: the normal
Rails server process and a local Tailwind process. To start them, run:

```
bin/dev
```
