class RequestsController < ApplicationController

  # GET /requests
  def index
    @requests = Request.all
    render json: @requests
  end

end
