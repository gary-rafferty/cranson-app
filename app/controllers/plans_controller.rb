class PlansController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    plans = Plan.all

    paginate json: plans, per_page: 50
  end

  def show
    @plan = Plan.find(params[:id])
    render json: @plan
  end

  def search
    if params[:query].present?
      @plans = Plan.search_by_address(params[:query])
      paginate json: @plans
    else
      render json: 'You must include query', status: :bad_request
    end
  end

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
