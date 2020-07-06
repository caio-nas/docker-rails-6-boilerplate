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
  gem 'devise-i18n'
  gem 'sidekiq', '~> 6.1', '>= 6.1.0'
  gem 'haml-rails', '~> 2.0'
  gem 'twitter-bootstrap-rails'

  gem_group :development, :test do
    gem 'rspec-rails'
    gem 'pry-rails'
    gem 'pry-byebug'
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

def cleanup
  remove_file 'template.rb'
  remove_file 'app/views/layouts/application.html.erb'
  remove_dir 'app_template'
  remove_dir 'config_template'
  run 'git remote remove origin'
end

def configure_locale
  environment "config.i18n.default_locale = 'pt-BR'"
end

def setup_git
  run "git config --global user.email 'caio.mvnascimento@gmail.com'"
  run "git config --global user.name 'Caio Nascimento'"

  git :init
  git add: '.'
  git commit: %Q{ -m 'Project Initial commit' }
end

# Main setup
source_paths
configure_locale
add_gems

after_bundle do
  copy_templates
  add_bootstrap
  add_sidekiq

  # Migrate
  add_users
  rails_command 'db:migrate:reset'

  cleanup
  setup_git

  say
  say 'Kickoff app successfully created! 👍', :green
  say
  say 'Switch to your app by running:'
  say '$ cd #{app_name}', :yellow
  say
  say 'Then run:'
  say '$ rails server', :green
end
