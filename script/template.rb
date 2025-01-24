app_name       = ENV['ST_APP_NAME']
use_ai        = ENV['ST_OPENAI_USE'] == 'true'

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

  say "Adding SnailTrain custom overrides..."
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

  if use_ai
    SCAFFOLD_FILE = File.join(__dir__, 'config', 'scaffolding.txt')
    scaffold_commands = File.read(SCAFFOLD_FILE)

    say "Running AI Scaffold Commands..."
    commands = scaffold_commands.split(";")
    commands.each_with_index do |command, index|
      command = command.strip
      generate command

      # TODO: change Thing.all to Current.user.things
      # TODO: remove user_id input on _form and in controller params
    end

    say "Replacing model files..."
    Dir.glob(File.join(__dir__, 'config', '*-model.txt')).each do |file|
      say "Replacing #{file}..."
      model_name = File.basename(file).gsub('-model.txt', '')
      model_file = File.join('app', 'models', "#{model_name}.rb")
      remove_file(model_file)
      create_file(model_file, File.read(file))
    end

    say "Adding navigation items..."
    NAV_FILE = File.join(__dir__, 'config', 'navigation.txt')
    nav_items = JSON.parse(File.read(NAV_FILE))
    header_file = 'app/views/application/_header.html.erb'
    content = File.read(header_file)
    nav_links = nav_items.map do |item|
      "<li><a href=\"/#{item.downcase}\" class=\"hover:underline\">#{item.capitalize}</a></li>"
    end.join("\n")
    new_content = content.gsub('<!-- Nav -->', nav_links)
    File.write(header_file, new_content)
    puts "Navigation items added successfully!"

    say "Cleaned up config files..."
    remove_file(SCAFFOLD_FILE) if File.exist?(SCAFFOLD_FILE)
    remove_file(NAV_FILE) if File.exist?(NAV_FILE)
    Dir.glob(File.join(__dir__, 'config', '*-model.txt')).each do |file|
      File.delete(file)
    end
  end

  say "Running migrations..."
  rails_command 'db:create db:migrate'

  say "Committing changes for initial git commit..."
  git :init
  git add: '.'
  git commit: %( -m "Initialized by SnailTrain.com" )
end
