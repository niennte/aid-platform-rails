# README

#### Initial setup
- rbenv
```
$ rbenv version
2.5.0
```
- Ruby
```
$ gem install rails -v 5.2.0
$ rbenv rehash
$ rails --version
Rails 5.2.1
```
- Rails
```
$ rails new aid-platform \
--api \
--database=postgresql
```

- Postgres
```
$ postgres --version
postgres (PostgreSQL) 9.3.5
```

Postgres:
[running locally](https://devcenter.heroku.com/articles/heroku-postgresql#set-up-postgres-on-mac)  
*also see*: config/database.yml

```$xslt
$ rails db:create
```
```$xslt
$ rails server
```
Smoke test: [localhost:3000](localhost:3000)

#


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
