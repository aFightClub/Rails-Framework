app_name = ENV['ST_APP_NAME']
use_ai = ENV['ST_OPENAI_USE'] == 'true'

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


  def modify_scaffold_files(name)
    name_plural = name.downcase.pluralize
    controller_path = "app/controllers/#{name_plural}_controller.rb"
    form_path = "app/views/#{name_plural}/_form.html.erb"
    single_path = "app/views/#{name_plural}/_#{name.downcase}.html.erb"

    if File.exist?(controller_path)
      content = File.read(controller_path)
      content.gsub!("#{name}.all", "Current.user.#{name_plural}")
      content.gsub!(
        /@#{name.downcase} = #{name}.new\(#{name.downcase}_params\)/,
        "@#{name.downcase} = #{name}.new(#{name.downcase}_params)\n    @#{name.downcase}.user_id = Current.user.id"
      )
      content.gsub!(", :user_id", "")
      File.write(controller_path, content)
    end

    if File.exist?(form_path)
      content = File.read(form_path)
      content.gsub!(%q{<div class="my-5">
    <%= form.label :user_id %>
    <%= form.text_field :user_id, class: ["block shadow rounded-md border outline-none px-3 py-2 mt-2 w-full", {"border-gray-400 focus:outline-blue-600": #{name.downcase}.errors[:user_id].none?, "border-red-400 focus:outline-red-600": #{name.downcase}.errors[:user_id].any?}] %>
  </div>}, '')
      File.write(form_path, content)
    end

    if File.exist?(single_path)
      content = File.read(form_path)
      content.gsub!(%q{<p class="my-5">
    <strong class="block font-medium mb-1">User:</strong>
    <%= contact.user_id %>
  </p>}, '')
      File.write(form_path, content)
    end
  end

  if use_ai
    SCAFFOLD_FILE = File.join(__dir__, 'config', 'scaffolding.txt')
    scaffold_commands = File.read(SCAFFOLD_FILE)

    say "Running AI Scaffold Commands..."
    commands = scaffold_commands.split(";")
    all_user_references = commands.select { |command| command.include?('user:references') }
    commands.each_with_index do |command, index|
      command = command.strip
      generate command
      modify_scaffold_files(command.split(' ')[1])
    end

    say "Change user model associations..."
    refs = []
    all_user_references.each do |command|
      refs << "has_many :#{command.split(' ')[1].downcase.pluralize}"
    end

    say "Append associations to user model..."
    user_model_path = "app/models/user.rb"
    if File.exist?(user_model_path)
      content = File.read(user_model_path)
      content.sub!(/end\s*\z/, "  #{refs.join("\n  ")}\nend")
      File.write(user_model_path, content)
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
