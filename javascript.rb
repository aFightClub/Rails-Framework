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
