=begin
Template Name: Rails 6 boilerplate
Author: Caio Nascimento
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb
=end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'devise'
  gem 'devise-i18n'
  gem 'sidekiq'
  gem 'haml-rails'
  gem 'twitter-bootstrap-rails'
  gem 'kaminari'
  gem 'awesome_print'
  gem 'draper'
  gem 'rack-attack'

  gem_group :development, :test do
    gem 'pry-rails'
    gem 'pry-byebug'
    gem 'bundler-audit'
    gem 'rails_best_practices'
  end

  gem_group :test do
    gem 'rspec-rails'
    gem 'factory_bot'
    gem 'faker'
  end

  gem_group :development do
    gem 'guard', require: false
    gem 'guard-rails_best_practices', require: false
    gem 'guard-rubocop', require: false
    gem 'guard-rspec', require: false
    gem 'better_errors'
    gem 'binding_of_caller'
  end
end

def add_users
  # Install Devise
  generate 'devise:install'

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, 'User', 'username', 'name', 'admin:boolean'

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob('db/migrate/*').max_by { |f| File.mtime(f) }
    gsub_file migration, /:admin/, ':admin, default: false'
  end
end

def copy_templates
  directory 'app_template', 'app', force: true
  directory 'config_template', 'config', force: true
end

def add_bootstrap
  run 'bundle exec rails g bootstrap:install static'
end

def add_sidekiq
  environment 'config.active_job.queue_adapter = :sidekiq'

  insert_into_file 'config/routes.rb',
    "require 'sidekiq/web'\n\n",
    before: 'Rails.application.routes.draw do'

  content = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY

  insert_into_file "config/routes.rb", "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def add_better_errors
  content = <<-RUBY
    if defined?(BetterErrors) && ENV['SSH_CLIENT']
      host = ENV['SSH_CLIENT'].match(/\\A([^\\s]*)/)[1]
      BetterErrors::Middleware.allow_ip! host if host
    end
  RUBY

  environment content, env: 'development'
end

def add_rspec
  run 'bundle exec rails generate rspec:install'
end

def configure_locale
  environment "config.i18n.default_locale = 'pt-BR'"
end

def configure_git
  run "git config --global user.email 'caio.mvnascimento@gmail.com'"
  run "git config --global user.name 'Caio Nascimento'"

  git :init
  git add: '.'
  git commit: %Q{ -m 'Project Initial commit' }
end

def add_draper
  run 'bundle exec rails generate draper:install'
end

def add_guard
  run 'bundle exec guard init'
  run 'bundle exec guard init rubocop'
  run 'bundle exec guard init rspec'
  run 'bundle exec guard init rails_best_practices'
end

def cleanup
  remove_file 'template.rb'
  remove_file 'app/views/layouts/application.html.erb'
  remove_dir 'app_template'
  remove_dir 'config_template'
  run 'git remote remove origin'
end

# Main setup
source_paths
configure_locale
add_gems

after_bundle do
  add_draper
  copy_templates
  add_bootstrap
  add_sidekiq
  add_rspec
  add_better_errors

  # Migrate
  add_users
  rails_command 'db:migrate:reset'

  cleanup
  configure_git

  say
  say 'Kickoff app successfully created! 👍', :green
  say
  say 'Switch to your app by running:'
  say '$ cd #{app_name}', :yellow
  say
  say 'Then run:'
  say '$ rails server', :green
end
