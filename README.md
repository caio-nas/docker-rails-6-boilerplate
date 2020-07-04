# docker-rails-6-boilerplate

```
$ git clone --bare git@github.com:caio-nas/docker-rails-6-boilerplate.git <YOUR_APP_NAME>
$ cd <YOUR_APP_NAME>
$ docker-compose run --rm web bundle install
$ docker-compose run --rm web bundle exec rails new . -m template.rb -d postgresql --skip-system-test --skip-action-text --skip-action-cable --skip-git -T # only for new projects
$ docker-compose run --rm web yarn install
$ docker-compose run --rm web bundle exec rails webpacker:install
$ docker-compose up -d
$ docker-compose exec web ./bin/rails db:create
```

You can see Rails top page on http://localhost:3000/.
