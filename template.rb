=begin
Template Name: Rails 6 boilerplate
Author: Caio Nascimento
Instructions: $ rails new myapp -d <postgresql, mysql, sqlite3> -m template.rb
=end

def source_paths
  [File.expand_path(File.dirname(__FILE__))]
end

def add_gems
  gem 'devise', '~> 4.7', '>= 4.7.1'
  gem 'sidekiq', '~> 6.1', '>= 6.1.0'
  gem 'therubyracer'
  gem 'less-rails'
  gem 'twitter-bootstrap-rails'

  gem 'pry-rails', :group => [:development, :test]
  gem 'pry-byebug', :group => [:development, :test]
end

def add_users
  # Install Devise
  generate "devise:install"

  # Configure Devise
  environment "config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }",
              env: 'development'

  route "root to: 'home#index'"

  # Create Devise User
  generate :devise, "User", "username", "name", "admin:boolean"

  # set admin boolean to false by default
  in_root do
    migration = Dir.glob("db/migrate/*").max_by{ |f| File.mtime(f) }
    gsub_file migration, /:admin/, ":admin, default: false"
  end
end

def copy_templates
  directory "app", force: true
end

def add_bootstrap
  run 'bundle exec rails g bootstrap:install less'
  run 'bundle exec rails g bootstrap:layout application'
end

def add_sidekiq
  environment "config.active_job.queue_adapter = :sidekiq"

  insert_into_file "config/routes.rb",
    "require 'sidekiq/web'\n\n",
    before: "Rails.application.routes.draw do"

  content = <<-RUBY
    authenticate :user, lambda { |u| u.admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  RUBY

  insert_into_file "config/routes.rb", "#{content}\n\n", after: "Rails.application.routes.draw do\n"
end

def remove_template_file
  remove_file "template.rb"
end

# Main setup
source_paths

add_gems

after_bundle do
  add_users
  add_sidekiq
  copy_templates
  add_bootstrap

  # Migrate
  rails_command "db:create"
  rails_command "db:migrate"

  remove_template_file

#   git :init
#   git add: "."
#   git commit: %Q{ -m "Initial commit" }

  say
  say "Kickoff app successfully created! 👍", :green
  say
  say "Switch to your app by running:"
  say "$ cd #{app_name}", :yellow
  say
  say "Then run:"
  say "$ rails server", :green
end
