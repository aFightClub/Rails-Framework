app_name       = ENV['ST_APP_NAME']
use_api        = ENV['ST_USE_API'] == 'true'
use_scaffold   = ENV['ST_USE_SCAFFOLD'] == 'true'
scaffold_name  = ENV['ST_SCAFFOLD_NAME']
scaffold_fields = ENV['ST_SCAFFOLD_FIELDS']

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
  say "Setting up your new Rails 8 app by SnailTrain.com..."
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

  if ENV['ST_OPENAI_USE'] == true && ENV['ST_OPENAI_DATA'].present?
    content = ENV['ST_OPENAI_DATA']
    scaffold_commands = content['scaffolding']

    puts "Running AI Scaffold Commands..."

    scaffold_commands.split(';').each do |command|
      command = command.strip

      puts "\nExecuting: #{command}"
      success = system("rails #{command}")

      if success
        puts "Successfully executed: #{command}"
      else
        puts "Failed to execute: #{command}"
      end
    end

    # todo replace models
    # add nav items
    # clean up config
  end

  git :init
  git add: '.'
  git commit: %( -m "Initialized by SnailTrain.com" )
end
