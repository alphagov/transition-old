class UserNeedsController < ApplicationController
  layout 'frontend'

  def index
    @user_need = UserNeed.new
  end

  def create
    @user_need = UserNeed.new(params[:user_need])
    if @user_need.save
      redirect_to user_needs_path, notice: "User need '#{@user_need.name}' saved"
    else
      render action: 'index'
    end
  end

  def edit
    @user_need = UserNeed.find(params[:id])
  end

  def update
    @user_need = UserNeed.find(params[:id])
    if @user_need.update_attributes(params[:user_need])
      redirect_to user_needs_path, notice: "User need '#{@user_need.name}' saved"
    else
      render action: 'edit'
    end
  end

  def destroy
    @user_need = UserNeed.find(params[:id])
    @user_need.destroy
    redirect_to user_needs_path, notice: "User need '#{@user_need.name}' deleted"
  end
end
