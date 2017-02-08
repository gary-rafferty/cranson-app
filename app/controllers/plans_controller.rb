class PlansController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
  end

  def show
    @plan = Plan.find(params[:id])
    render json: @plan
  end

  def search
    if params[:query].present?
      @plans = Plan.search_by_address(params[:query])
      render json: @plans
    else
      render json: 'You must include query', status: :bad_request
    end
  end

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
