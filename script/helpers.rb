remove_file 'app/helpers/application_helper.rb'
create_file 'app/helpers/application_helper.rb', <<~RUBY
  module ApplicationHelper
    include Pagy::Frontend
  end
RUBY
