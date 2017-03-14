class PlansController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def index
    plans = Plan.all

    paginate json: plans, per_page: 50
  end

  def show
    @plan = Plan.find(params[:id])
    render json: @plan, with_audits: true
  end

  def search
    if params[:query].present?
      @plans = Plan.search_by_address(params[:query])
      paginate json: @plans
    else
      render json: 'You must include query', status: :bad_request
    end
  end

  def within
    if params[:kilometres].present? && params[:latlng].present?
      @plans = Plan.within_kilometres_of(params[:kilometres], params[:latlng].split(','))
      paginate json: @plans
    else
      render json: 'You must include kilometres and latlng', status: :bad_request
    end
  end

  def decided
    plans = Plan.decided

    paginate json: plans, per_page: 50
  end

  def invalid
    plans = Plan.invalid_or_withdrawn

    paginate json: plans, per_page: 50
  end

  def unknown
    plans = Plan.unknown

    paginate json: plans, per_page: 50
  end

  def pending
    plans = Plan.pending

    paginate json: plans, per_page: 50
  end

  def on_appeal
    plans = Plan.on_appeal

    paginate json: plans, per_page: 50
  end

  private

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end
end
