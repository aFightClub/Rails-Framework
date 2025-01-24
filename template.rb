app_name       = ENV['APP_NAME']
use_api        = ENV['USE_API'] == 'true'
use_scaffold   = ENV['USE_SCAFFOLD'] == 'true'
scaffold_name  = ENV['SCAFFOLD_NAME']
scaffold_fields = ENV['SCAFFOLD_FIELDS']

gem 'sqlite3'
gem 'tailwindcss-rails', '~> 3.3'
gem 'rack-cors', require: 'rack/cors'
gem 'ruby-openai'
gem 'chartkick'
gem 'groupdate'
gem 'pagy', '~> 9.3'
gem 'meta-tags'
gem 'faker'

after_bundle do
  say "Setting up your new Rails app..."
  rails_command 'tailwindcss:install'
  generate 'meta_tags:install'
  generate 'authentication'
  rails_command 'db:create db:migrate'

  apply File.join(File.dirname(__FILE__), 'gemfile.rb')
  apply File.join(File.dirname(__FILE__), 'javascript.rb')
  apply File.join(File.dirname(__FILE__), 'tailwind.rb')
  apply File.join(File.dirname(__FILE__), 'controllers.rb')
  apply File.join(File.dirname(__FILE__), 'views.rb')
  apply File.join(File.dirname(__FILE__), 'routes.rb')
  apply File.join(File.dirname(__FILE__), 'database.rb')
  apply File.join(File.dirname(__FILE__), 'models.rb')
  apply File.join(File.dirname(__FILE__), 'partials.rb')
  apply File.join(File.dirname(__FILE__), 'readme.rb')

  if use_api
    say "Configuring for API mode..."
  end

  if use_scaffold && !scaffold_name.strip.empty?
    say "Generating scaffold for #{scaffold_name} with fields: #{scaffold_fields}"
    rails_command "generate scaffold #{scaffold_name} #{scaffold_fields}"
    rails_command "db:migrate"
  end

  git :init
  git add: '.'
  git commit: %( -m "Initialized Rails 8 Framework by aFightClub.app" )
end
