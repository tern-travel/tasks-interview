# README

This application is intended to serve as the starting point for a basic
pair programming interview.

## Installation

We use a `.ruby-version` and `.ruby-gemset` file to indicate to your local
Ruby version manager the correct version of Ruby to use. Refer to those files
if you're manually managing your Ruby installation.

We use PostgreSQL 15 as our primary persistence store. On Mac OS, use [Homebrew](https://brew.sh)
to install PostgreSQL 15.

```
brew install postgresql@15
```

To install Rubygem dependencies, simply use Bundler:

```
bundle install
```

You may need to give Bundler some help to locate your local PostgreSQL installation:

```
# Intel Mac
bundle config build.pg --with-pg-config=/usr/local/opt/postgresql@15/bin/pg_config

# Apple Silicon Mac
bundle config build.pg --with-pg-config=/usr/local/opt/postgresql@15/bin/pg_config
```

Verify the `pg_config` path above with your local installation - it may differ.

## Bootstrapping the Database

To get your local database setup, use the built-in Rails database management
commands:

```
bin/rails db:create db:migrate db:seed
```

Refer to the `config/database.yml` file for details on the local database name
and connection information.
## Local Development

Since we use the `tailwindcss-rails` gem to pull in the [Tailwind CSS library](https://tailwindcss.com),
the local development environment requires two separate process: the normal
Rails server process and a local Tailwind process. To start them, run:

```
bin/dev
```
