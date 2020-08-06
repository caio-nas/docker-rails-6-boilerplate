# Release the kraken!

Get up and running with a ton of code that you don't have time to understand and would just copy and paste anyway! \o/

```
$ git clone --depth 1 git@github.com:caio-nas/docker-rails-6-boilerplate.git <YOUR_APP_NAME>

$ cd <YOUR_APP_NAME>
$ docker-compose run --rm web bundle install

# only for new projects
$ docker-compose run --rm web bundle exec rails new . -m template.rb -d postgresql --skip-system-test --skip-action-text --skip-action-cable --skip-git -f -T

$ sudo chown -R $USER:$USER .
$ docker-compose up -d
```

You can see Rails top page on http://localhost:3000/.

## TODO

twitter-bootstrap-rails is creating another application.js on the rails 5 old path
