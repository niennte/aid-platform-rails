class ResponsesController < ApplicationController

  # GET /response
  def index
    @responses = Response.all
    render json: @responses
  end

  # GET /response/1
  def show
    @response = Response.find(params[:id])
    if @response
      render json: @response
    else
      render status: :not_found
    end
  end

  # POST /response
  def create
    @response = Response.new(response_params)
    @response.user = current_user
    if @response.save
      render json: @response, status: :created, location: @response
    else
      render json: {errors: @response.errors, response: @response}, status: :unprocessable_entity
    end

  end

  # PATCH/PUT /response/1
  def update
    @response = Response.find(params[:id])
    if @response.update(response_params)
      render json: @response, status: :ok, location: @response
    else
      render json: @response.errors, status: :unprocessable_entity
    end

  end

  # DELETE /response/1
  def destroy
    @response = Response.find(params[:id])
    @response.destroy
    render status: :no_content
  end

  def response_params
    params.require(:response).permit(:id, :request_id, :user_id, :message)
  end
end
