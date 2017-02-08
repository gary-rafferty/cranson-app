class PlansController < ApplicationController
  def index
  end

  def search
    if params[:query].present?
      @plans = Plan.search_by_address(params[:query])
      render json: @plans
    else
      render json: 'You must include query', status: :bad_request
    end
  end
end
