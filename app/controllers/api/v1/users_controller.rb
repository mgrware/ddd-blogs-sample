class Api::V1::UsersController < ApplicationController
  def index
    @users = Users::User.order("id DESC")
    render json: {data: @users}
  end

  def show
    @users = Users::User.find_by_uid(params[:id])
    render json: {data: @users}
  end

  def create
    ApplicationRecord.transaction do
      submit_user
    end
    
    render json: { messages: "User was successfully created", data: { user_id: @uuid}}
  end

  private

  def submit_user
    @uuid = SecureRandom.uuid
    command_bus.(create_customer_cmd(@uuid, params[:name]))
  end

  def create_customer_cmd(user_id, name)
    Crm::RegisterUser.new(user_id: user_id, name: name)
  end

end