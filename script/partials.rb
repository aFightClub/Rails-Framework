create_file 'app/views/application/_header.html.erb', <<~ERB
  <header class="bg-black py-2 mb-3 text-white">
    <nav class="container mx-auto flex items-center justify-between py-4">
      <a href="/" class="text-2xl font-bold">
        #{ENV['ST_APP_NAME'].capitalize}
      </a>
      <ul class="flex items-center space-x-4">
        <li><a href="/" class="hover:underline">Dashboard</a></li>
        <!-- Nav -->
        <li><a href="/account" class="hover:underline">Account</a></li>
      </ul>
    </nav>
  </header>
ERB

create_file 'app/views/application/_footer.html.erb', <<~ERB
  <footer class="pt-3 pb-12 text-gray-600 text-sm">
    <nav class="container mx-auto flex items-center justify-between py-4">
      <span>&copy; 2025 – <strong>#{ENV['ST_APP_NAME'].capitalize}</strong> – Powered by <a href="https://afightclub.app" target="_blank" class="underline text-gray-500">aFightClub.app</a></span>
      <span><%= button_to "Logout", session_path, method: :delete if authenticated? %></span>
    </nav>
  </footer>
ERB

create_file 'app/views/application/_popup.html.erb', <<~ERB
  <div class="fixed inset-0 z-50 flex items-center justify-center">
    <div class="absolute inset-0 bg-black opacity-50"></div>

    <div class="relative z-50 bg-white rounded-lg shadow-xl p-6 max-w-md w-full mx-4">
      <div class="text-gray-800">
        <% if local_assigns[:title] %>
          <h2 class="text-xl font-bold mb-4"><%= title %></h2>
        <% end %>

        <div class="mb-4">
          <%= yield if block_given? %>
        </div>

        <div class="flex justify-end">
          <% if local_assigns[:close_button] != false %>
            <button data-action="click->popup#hide" data-id="<%= local_assigns[:id] %>" class="absolute -top-2 -right-2 border text-slate-600 rounded-full p-2 bg-slate-100">
              <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 1216 1312"><path fill="currentColor" d="M1202 1066q0 40-28 68l-136 136q-28 28-68 28t-68-28L608 976l-294 294q-28 28-68 28t-68-28L42 1134q-28-28-28-68t28-68l294-294L42 410q-28-28-28-68t28-68l136-136q28-28 68-28t68 28l294 294l294-294q28-28 68-28t68 28l136 136q28 28 28 68t-28 68L880 704l294 294q28 28 28 68"/></svg>
            </button>
          <% end %>
        </div>
      </div>
    </div>
  </div>
ERB
