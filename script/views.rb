create_file 'app/views/registration/new.html.erb', <<~ERB
  <div class="mx-auto md:w-3/4 w-full">
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
        <button class="btn btn-primary w-full text-center block">Create Account</button>
      </div>

      <div>
        <hr class="my-6 border" />
        <a href="/login" class="btn btn-secondary w-full text-center block">I'm already a member!</a>
      </div>
    <% end %>
  </div>
ERB

remove_file 'app/views/sessions/new.html.erb'
create_file 'app/views/sessions/new.html.erb', <<~ERB
  <div class="mx-auto md:w-3/4 w-full">
    <% if alert = flash[:alert] %>
      <p class="py-2 px-3 bg-red-50 mb-5 text-red-500 font-medium rounded-lg inline-block" id="alert"><%= alert %></p>
    <% end %>

    <% if notice = flash[:notice] %>
      <p class="py-2 px-3 bg-green-50 mb-5 text-green-500 font-medium rounded-lg inline-block" id="notice"><%= notice %></p>
    <% end %>

    <%= form_with url: session_url, class: "contents" do |form| %>
      <div class="mb-5">
        <label class="label">Email Address</label>
        <%= form.email_field :email_address, required: true, autofocus: true, autocomplete: "username", placeholder: "Enter your email address", value: params[:email_address], class: "block shadow rounded-md border border-gray-400 focus:outline-blue-600 px-3 py-2 mt-1 w-full" %>
      </div>

      <div class="my-5">
        <label class="label">Password</label>
        <%= form.password_field :password, required: true, autocomplete: "current-password", placeholder: "Enter your password", maxlength: 72, class: "block shadow rounded-md border border-gray-400 focus:outline-blue-600 px-3 py-2 mt-1 w-full" %>
      </div>

      <div class="col-span-6 sm:flex sm:items-center sm:gap-4">
        <div class="inline">
          <%= form.submit "Sign in", class: "rounded-md px-3.5 py-2.5 bg-blue-600 hover:bg-blue-500 text-white inline-block font-medium cursor-pointer" %>
        </div>

        <div class="mt-4 text-sm text-gray-500 sm:mt-0">
          <%= link_to "Forgot password?", new_password_path, class: "text-gray-700 underline hover:no-underline" %>
        </div>
      </div>
    <% end %>

    <hr class="mb-6 mt-6 border-2 border-slate-200">

    <a href="/register" class="btn btn-secondary w-full text-center block">Create Your Account</a>
  </div>
ERB

create_file 'app/views/dashboard/index.html.erb', <<~ERB
  <h1 class="text-4xl font-fancy font-bold mb-3">Welcome back!</h1>
  <p>Lorem ipsum dolor sit amet consectetur adipisicing elit. Corrupti distinctio saepe inventore, aspernatur numquam animi voluptatem nam! Minima distinctio magni iste perferendis quasi pariatur! Nesciunt consequatur quam ducimus reiciendis non?</p>
ERB

create_file 'app/views/account/index.html.erb', <<~ERB
  <h1 class="text-4xl font-fancy font-bold mb-3">Account</h1>
  <p class="mb-6 text-slate-600 text-lg">You are currently on the <strong>Starter Plan</strong>.</p>
  <%= link_to "Change Password", edit_password_url(Current.user.password_reset_token), class: 'btn btn-secondary inline-block' %>
  <p class="text-slate-600 mb-3 mt-6">You are currently signed in with <%= Current.user.email_address %></p>
ERB

remove_file 'app/views/layouts/application.html.erb'
create_file 'app/views/layouts/application.html.erb', <<~ERB
  <!DOCTYPE html>
  <html>
    <head>
      <%= display_meta_tags site: "#{ENV['ST_APP_NAME']}" %>
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <meta name="apple-mobile-web-app-capable" content="yes">
      <meta name="mobile-web-app-capable" content="yes">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>
      <%= yield :head %>
      <link rel="icon" href="/icon.png" type="image/png">
      <link rel="icon" href="/icon.svg" type="image/svg+xml">
      <link rel="apple-touch-icon" href="/icon.png">
      <%= stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload" %>
      <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
      <%= javascript_importmap_tags %>
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Roboto+Condensed:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    </head>

    <body data-controller="notice" class="bg-slate-100">
      <%= render "header" %>

      <main class="container mx-auto card p-12">
        <%= yield %>
      </main>

      <% if notice.present? || alert.present? %>
        <div id="notices">
          <p class="notice"><%= notice %></p>
          <p class="alert"><%= alert %></p>
        </div>
      <% end %>

      <%= render "footer" %>
    </body>
  </html>
ERB

create_file 'app/views/layouts/auth.html.erb', <<~ERB
  <!DOCTYPE html>
  <html>
    <head>
      <%= display_meta_tags site: "#{ENV['ST_APP_NAME']}" %>
      <meta name="viewport" content="width=device-width,initial-scale=1">
      <meta name="apple-mobile-web-app-capable" content="yes">
      <meta name="mobile-web-app-capable" content="yes">
      <%= csrf_meta_tags %>
      <%= csp_meta_tag %>
      <%= yield :head %>
      <link rel="icon" href="/icon.png" type="image/png">
      <link rel="icon" href="/icon.svg" type="image/svg+xml">
      <link rel="apple-touch-icon" href="/icon.png">
      <%= stylesheet_link_tag "tailwind", "inter-font", "data-turbo-track": "reload" %>
      <%= stylesheet_link_tag :app, "data-turbo-track": "reload" %>
      <%= javascript_importmap_tags %>
      <link rel="preconnect" href="https://fonts.googleapis.com">
      <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
      <link href="https://fonts.googleapis.com/css2?family=Inter:ital,opsz,wght@0,14..32,100..900;1,14..32,100..900&family=Roboto+Condensed:ital,wght@0,100..900;1,100..900&display=swap" rel="stylesheet">
    </head>

    <body class="bg-slate-100">
      <header class="py-2 mt-12">
        <nav class="container auth mx-auto flex items-center justify-center py-4">
          <a href="/" class="text-5xl font-bold">
            #{ENV['ST_APP_NAME']}
          </a>
        </nav>
      </header>

      <main class="container-sm card p-6 py-12 mx-auto">
        <%= yield %>
      </main>

      <footer class="pt-3 pb-12 text-sm">
        <nav class="container auth mx-auto flex items-center justify-center py-4">
          <span>&copy; 2025 – <strong>#{ENV['ST_APP_NAME']}</strong> – Powered by <a href="https://afightclub.app" target="_blank" class="underline">aFightClub.app</a></span>
        </nav>
      </footer>
    </body>
  </html>
ERB
