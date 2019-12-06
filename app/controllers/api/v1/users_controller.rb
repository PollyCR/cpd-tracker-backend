class Api::V1::UsersController < ApplicationController
    def create
        user = User.create(user_params)
        if user.valid?
            jwt_token = encode_token(user_id: user.id)
            cookies.signed[:jwt] = {value: jwt_token, httponly: true, expires: 1.hour.from_now}

            render json: { user: UserSerializer.new(user) }
        else
            render json: { errors: user.errors.full_messages }, status: :not_acceptable
        end
    end
    private

    def user_params
        params.require(:user).permit(:email, :password)
    end
end
