# Community Aid Platform

A prototype of a one-to-many match making platform, based on geolocation and offering to members an ability to either publish a "request" or respond / volunteer for a "request" published by another member. 

![](https://s3.amazonaws.com/quod.erat.demonstrandum/portfolio/img/aid-platform/Screen+Shot+2019-02-08+at+12.10.53.png)

- [Live demo](https://infinite-sierra-74007.herokuapp.com/)
- [More screenshots](https://github.com/niennte/aid-platform/wiki#screenshots)

#### Documentation / Wiki
- [What does it do?](https://github.com/niennte/aid-platform/wiki#what-does-it-do)
- [Stack and architecture](https://github.com/niennte/aid-platform/wiki#stack-and-architecture)
- [Is it perfect?](https://github.com/niennte/aid-platform/wiki#is-it-perfect)
- [Is it any good?](https://github.com/niennte/aid-platform/wiki#is-it-any-good)
- [What is it good for?](https://github.com/niennte/aid-platform/wiki#what-is-it-good-for)
- [Why would I want to build ~~anything as crazy as that~~ an abstract prototype?](https://github.com/niennte/aid-platform/wiki#why-would-i-want-to-build-anything-as-crazy-as-that-an-abstract-prototype)

#### Live demo
- [is here](https://infinite-sierra-74007.herokuapp.com/) (please bear with two heroku instances waking up)

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

# set up environment variables for the JWT signing secret
$ rails secret
[rails-generated-secret]


dev:
$ DEVISE_JWT_SECRET_KEY=[rails-generated-secret] rails server

prod: 
$ heroku config:set DEVISE_JWT_SECRET_KEY = [rails-generated-secret] 

# activate the app
$ heroku ps:scale web=1
Scaling dynos... done, now running web at 1:Free

```

#
Setup Redis notifications for the [interesting events (all of the keyspace)](https://redis.io/topics/notifications):
```
config set notify-keyspace-events KA
```

