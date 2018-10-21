class RequestsController < ApplicationController

  # GET /request
  def index
    @requests = Request.all
    render json: @requests
  end

  # GET /request/1
  # GET /request/1.json
  def show
    @request = Request.find(params[:id])
    if @request
      render json: @request
    else
      render status: :not_found
    end
  end

  # POST /request
  # POST /request.json
  def create
    @request = Request.new(request_params)
    @request.user = current_user
    if @request.save
      render json: @request, status: :created, location: @request
    else
      render json: {errors: @request.errors, request: @request}, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /request/1
  # PATCH/PUT /request/1.json
  def update
    @request = Request.find(params[:id])
    if @request.update(request_params)
      render json: @request, status: :ok, location: @request
    else
      render json: @request.errors, status: :unprocessable_entity
    end

  end

  # DELETE /request/1
  # DELETE /request/1.json
  def destroy
    @request = Request.find(params[:id])
    @request.destroy
    render status: :no_content
  end

  def request_params
    params.require(:request).permit(:id, :user_id, :category, :status, :title, :description, :address, :category)
  end

end
