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

  create_file 'app/controllers/registration_controller.rb', <<~RUBY
    class RegistrationController < ApplicationController
      allow_unauthenticated_access

      def new
        @user = User.new
        render layout: "auth"
      end

      def create
        @user = User.new(user_params)
        unless params[:user][:invite_code] == "fightclub"
          redirect_to new_registration_path, alert: "Invalid invite code."
          return
        end
        if User.exists?(email_address: user_params[:email_address])
          redirect_to new_registration_path, alert: "This email is already registered."
          return
        end
        if @user.save
          start_new_session_for @user
          redirect_to root_path, notice: "User successfully signed up."
        else
          redirect_to new_registration_path, alert: @user.errors.full_messages.join("\\n")
        end
      end

      private

      def user_params
        params.require(:user).permit(:email_address, :password, :password_confirmation, :invite_code)
      end
    end
  RUBY

  create_file 'app/views/registration/new.html.erb', <<~ERB
    <div class="card">
      <% if alert = flash[:alert] %>
        <p class="py-2 px-3 bg-red-50 mb-5 text-red-500 font-medium rounded-lg inline-block" id="alert"><%= alert %></p>
      <% end %>
      <% if notice = flash[:notice] %>
        <p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block" id="notice"><%= notice %></p>
      <% end %>
      <h1 class="font-bold text-4xl">Register</h1>
      <%= form_with model: @user, url: registration_url, local: true, class: "contents" do |form| %>
        <div class="my-5">
          <label class="label">Invite Code</label>
          <%= form.password_field :invite_code, required: true, placeholder: "Exclusive invite code...", autofocus: true, autocomplete: 'new-password', value: params[:invite_code],
          class: "block shadow rounded-md border border-gray-400 focus:outline-blue-600 px-3 py-2 mt-2 w-full" %>
        </div>
        <div class="my-5">
          <label class="label">Email Address</label>
          <%= form.email_field :email_address, required: true, placeholder: "Your email address", value: params[:email_address],
          class: "block shadow rounded-md border border-gray-400 focus:outline-blue-600 px-3 py-2 mt-2 w-full" %>
        </div>
        <div class="my-5">
          <label class="label">Password</label>
          <%= form.password_field :password, required: true, placeholder: "Enter your password", maxlength: 72, autocomplete: 'new-password',
          class: "block shadow rounded-md border border-gray-400 focus:outline-blue-600 px-3 py-2 mt-2 w-full" %>
        </div>
        <div class="my-5">
          <label class="label">Confirm Password</label>
          <%= form.password_field :password_confirmation, required: true, autocomplete: 'new-password', placeholder: "Confirm your password",
          maxlength: 72, class: "block shadow rounded-md border border-gray-400 focus:outline-blue-600 px-3 py-2 mt-2 w-full" %>
        </div>
        <div>
          <button class="btn btn-primary">Create Account</button>
        </div>
        <div>
          <hr class="my-6 border" />
          <a href="/login" class="btn btn-secondary inline-block">I'm already a member!</a>
        </div>
      <% end %>
    </div>
  ERB

  route 'get "register", to: "registration#new", as: :new_registration'
  route 'post "register", to: "registration#create", as: :registration'

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
