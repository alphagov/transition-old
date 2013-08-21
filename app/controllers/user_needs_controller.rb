class UserNeedsController < ApplicationController

  def index
    @user_need = UserNeed.new
  end

  def create
    @user_need = UserNeed.new(params[:user_need])
    if @user_need.save
      redirect_to user_needs_path(last_org_id: @user_need.organisation.id), notice: "User need saved"
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
      redirect_to user_needs_path, notice: "User need saved"
    else
      render action: 'edit'
    end
  end

  def destroy
    @user_need = UserNeed.find(params[:id])
    if @user_need.urls.empty?
      @user_need.destroy
      redirect_to user_needs_path, notice: "User need deleted"
    else
      flash.now[:error] = 'The User Need has been associated to one or more Urls and therefore cannot be deleted'
      render action: 'edit'
    end
  end
end
