# sigafila-backend

```
$ git clone git@github.com:caio-nas/sigafila-backend.git
$ cd sigafila-backend
$ docker-compose run --rm web bundle install
$ bundle exec rails new sigafila -d postgresql --skip-action-text --skip-action-cable --skip-system-test # only for new projects
$ docker-compose run --rm web bundle exec rails webpacker:install
$ docker-compose up
$ docker-compose exec web ./bin/rails db:create
```

You can see Rails top page on http://localhost:3000/.
