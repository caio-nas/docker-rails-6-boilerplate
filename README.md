# docker-rails-6-boilerplate

```
$ git clone git@github.com:caio-nas/docker-rails-6-boilerplate.git
$ mv docker-rails-6-boilerplate <YOUR_APP_NAME>
$ cd <YOUR_APP_NAME>
$ docker-compose run --rm web bundle install
$ bundle exec rails new . -d postgresql --skip-action-text --skip-action-cable --skip-system-test # only for new projects
$ docker-compose run --rm web bundle exec rails webpacker:install
$ docker-compose up
$ docker-compose exec web ./bin/rails db:create
```

You can see Rails top page on http://localhost:3000/.
