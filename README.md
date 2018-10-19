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
Deployment:
- [prepare for deployment](https://devcenter.heroku.com/articles/heroku-postgresql#set-up-postgres-on-mac)

```
$ cd [project root]
```

```
# create and connect the remote app
$ heroku create
# verify:
$ git remote -v
...
heroku	https://git.heroku.com/[heroku app name].git (fetch)
heroku	[heroku app name].git (push)
...
# deploy
$ git push heroku master
...
remote:        https://[heroku app name].herokuapp.com/ deployed to Heroku
...
remote: Verifying deploy... done.
To https://git.heroku.com/[heroku app name].git

# initiate database:
$ heroku run rails db:migrate

# activate the app
$ heroku ps:scale web=1
Scaling dynos... done, now running web at 1:Free

```


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
