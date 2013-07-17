class Admin::ContentTypesController < ApplicationController

  def index
    @content_types = ContentType.all
  end

  def new
    @content_type = ContentType.new
  end

  def create
    @content_type = ContentType.new(params[:content_type])
    if @content_type.save
      redirect_to admin_content_types_path, notice: "Content type '#{@content_type}' saved"
    else
      render action: 'new'
    end
  end

  def edit
    @content_type = ContentType.find(params[:id])
  end

  def update
    @content_type = ContentType.find(params[:id])
    if @content_type.update_attributes(params[:content_type])
      redirect_to admin_content_types_path(@site), notice: "Content type '#{@content_type}' saved"
    else
      render action: 'edit'
    end
  end

  def destroy
    @content_type = ContentType.find(params[:id])
    @content_type.destroy
    redirect_to admin_content_types_path(@site), notice: "Content type '#{@content_type}' deleted"
  end
end
