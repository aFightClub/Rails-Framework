remove_file 'app/models/user.rb'
create_file 'app/models/user.rb', <<~RUBY
  class User < ApplicationRecord
    attr_accessor :invite_code
    has_secure_password
    has_many :sessions, dependent: :destroy
    normalizes :email_address, with: ->(e) { e.strip.downcase }
  end
RUBY
