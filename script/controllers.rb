create_file 'app/controllers/registration_controller.rb', <<~RUBY
  class RegistrationController < ApplicationController
    allow_unauthenticated_access

    def new
      set_meta_tags(
        title: "Register"
      )
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

create_file 'app/controllers/dashboard_controller.rb', <<~RUBY
  class DashboardController < ApplicationController
    def index
      set_meta_tags(
        title: "Dashboard"
      )
    end
  end
RUBY

create_file 'app/controllers/account_controller.rb', <<~RUBY
  class AccountController < ApplicationController
    def index
      set_meta_tags(
        title: "Account"
      )
    end
  end
RUBY

remove_file 'app/controllers/application_controller.rb'
create_file 'app/controllers/application_controller.rb', <<~RUBY
  class ApplicationController < ActionController::Base
    before_action :resume_session
    include Authentication
    include Pagy::Backend
    allow_browser versions: :modern
  end
RUBY

remove_file 'app/controllers/sessions_controller.rb'
create_file 'app/controllers/sessions_controller.rb', <<~RUBY
  class SessionsController < ApplicationController
    allow_unauthenticated_access only: %i[ new create ]
    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

    def new
      render layout: "auth"
    end

    def create
      if user = User.authenticate_by(params.permit(:email_address, :password))
        start_new_session_for user
        redirect_to after_authentication_url
      else
        redirect_to new_session_path, alert: "Try another email address or password."
      end
    end

    def destroy
      terminate_session
      redirect_to new_session_path
    end
  end
RUBY

remove_file 'app/controllers/passwords_controller.rb'
create_file 'app/controllers/passwords_controller.rb', <<~RUBY
  class PasswordsController < ApplicationController
    allow_unauthenticated_access
    before_action :set_user_by_token, only: %i[ edit update ]

    def new
      render layout: "auth"
    end

    def create
      if user = User.find_by(email_address: params[:email_address])
        PasswordsMailer.reset(user).deliver_later
      end

      redirect_to new_session_path, notice: "Password reset instructions sent (if user with that email address exists)."
    end

    def edit
    end

    def update
      if @user.update(params.permit(:password, :password_confirmation))
        redirect_to new_session_path, notice: "Password has been reset."
      else
        redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
      end
    end

    private
      def set_user_by_token
        @user = User.find_by_password_reset_token!(params[:token])
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        redirect_to new_password_path, alert: "Password reset link is invalid or has expired."
      end
  end
RUBY
