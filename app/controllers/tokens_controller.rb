class TokensController < ApplicationController
  def validate
    token = params[:access_token]
    token_record = Token.where(access_token: token).first

    if token_record && Token.valid?(token_record)
      render json: { user_id: token_record.user._id, email: token_record.user.email }, status: :ok
    else
      render json: { message: 'Invalid token' }, status: :unauthorized
    end
  end
end
