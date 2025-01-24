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
  rails_command 'tailwindcss:install'
  generate 'meta_tags:install'
  generate 'authentication'
  rails_command 'db:create db:migrate'

  importmap_path = 'config/importmap.rb'
  importmap_pins = <<~RUBY

    pin "chartkick", to: "chartkick.js"
    pin "Chart.bundle", to: "Chart.bundle.js"
  RUBY

  if File.exist?(importmap_path)
    append_to_file importmap_path, importmap_pins
  else
    create_file importmap_path, importmap_pins
  end

  application_js_path = 'app/javascript/application.js'
  chartkick_imports = <<~JS

    import "chartkick"
    import "Chart.bundle"
  JS

  if File.exist?(application_js_path)
    append_to_file application_js_path, chartkick_imports
  else
    create_file application_js_path, chartkick_imports
  end

  tailwind_path = 'app/assets/stylesheets/application.tailwind.css'
  tailwind_imports = <<~CSS
    @import "tailwindcss/base";
    @import "tailwindcss/components";
    @import "tailwindcss/utilities";
  CSS

  if File.exist?(tailwind_path)
    append_to_file tailwind_path, tailwind_imports
  else
    create_file tailwind_path, tailwind_imports
  end

  remove_file 'README.md'
  create_file 'README.md', <<~README
    # Rails 8 Framework
    This application was generated from our Ruby on Rails 8 Framework template by aFightClub.app.

    ## Rails 8:
    - PostgreSQL
    - SQLite3 (for Solid Queue)

    ## Gem List:
    - TailwindCSS
    - Rack-CORS
    - Ruby OpenAI
    - Chartkick
    - Groupdate
    - Pagy
    - SQLite3
    - Meta Tags
    - Faker

    ## Deployment:
    - Kamal 2
    - Docker
  README

  git :init
  git add: '.'
  git commit: %( -m "Initialized Rails 8 Framework by aFightClub.app" )
end
