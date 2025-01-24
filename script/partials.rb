create_file 'app/views/application/_header.html.erb', <<~ERB
  <header class="bg-black py-2 mb-3 text-white">
    <nav class="container mx-auto flex items-center justify-between py-4">
      <a href="/" class="text-2xl font-bold">
        #{ENV['ST_APP_NAME']}
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
      <span>&copy; 2025 – <strong>#{ENV['ST_APP_NAME']}</strong> – Powered by <a href="https://afightclub.app" target="_blank" class="underline text-gray-500">aFightClub.app</a></span>
      <span><%= button_to "Logout", session_path, method: :delete if authenticated? %></span>
    </nav>
  </footer>
ERB
