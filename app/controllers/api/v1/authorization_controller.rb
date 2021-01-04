class Api::V1::AuthorizationController < ApplicationController
    skip_before_action :authorized, only: [:create]

    #login
    def create
      user = User.find_by(username: user_login_params[:username])
      #User#authenticate comes from BCrypt
      if user && user.authenticate(user_login_params[:password])
        # encode token comes from ApplicationController
        token = encode_token({ user_id: user.id })
        render json: { user: UserSerializer.new(user), jwt: token }, status: :accepted
      else
        errors = {}
        
        if !!!user
          errors[:username] = ["User Not Found"]
        elsif !user.authenticate(user_login_params[:password])
          errors[:password] = ["Password doesn't match user"] 
        end

        render json: { message: 'Invalid username or password', errors: errors}, status: :unauthorized
      end
    end
  
    private
  
    def user_login_params
      # params { user: {username: 'Chandler Bing', password: 'hi' } }
      params.require(:user).permit(:username, :password)
    end
end
