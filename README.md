# Release the kraken!
###### Caio Nascimento (@caio-nas) - https://www.linkedin.com/in/caiomvnascimento/

Get up and running with a ton of code that you don't have time to understand and would just copy and paste anyway! \o/

### Requirements

- docker-compose version 1.23
- internet connection to download containers

### How to run

```
git clone git@github.com:caio-nas/release-the-kraken.git <YOUR_APP_NAME>
cd <YOUR_APP_NAME>

-- for new projects
  -- If you have Make installed
    make new

  -- Otherwise
    docker-compose run --rm web bundle install
    docker-compose run --rm web bundle exec rails new . -m template.rb -d postgresql --skip-system-test --skip-action-text --skip-action-cable --skip-git -f -T
    docker-compose up -d

-- for cloned projects
  -- If you have Make installed
    make setup

  -- Otherwise
	docker-compose run --rm web bundle install
	docker-compose up -d
	docker-compose exec web yarn install --check-files
	docker-compose exec web bundle exec rails db:setup

# recommended but not required
sudo chown -R $USER:$USER .
```

It will build the docker containers and start the application. This could take a while :-)

After that, you can see Rails top page on http://localhost:3000/.

### How to test

```
-- If you have Make installed
  make test

-- Otherwise
  docker-compose exec web bundle exec rspec
```

### How to use

Login with credentials:

- email: admin@example.com
- password: 123@qwe


## TODO

twitter-bootstrap-rails is creating another application.js on the rails 5 old path
