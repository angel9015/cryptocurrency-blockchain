class BusinessesController < ApplicationController
  def index
    scope = Business.all.approved
    if params[:search]
      @businesses = scope.where('name ILIKE ?', "%#{params[:search]}%")
    elsif params[:category_search]
      @businesses = scope.where(business_category_id: params[:category_search])
    elsif params[:region_search]
      @businesses = scope.where(region_id: params[:region_search])
    else
      @businesses = scope
    end
    render layout: "landing_page"
  end

  def show
    @business= Business.find(params[:id])
    render layout: "landing_page"
  end

  def edit
    @business = Business.find(params[:id])
    authorize @business
    render layout: "form_page"
  end

  def update
    @business = Business.find(params[:id])
    authorize @business
    if @business.update_attributes(business_params)
     flash[:success] = "Business Updated!"
     redirect_to @business
    else
      render 'edit'
    end
  end

  private
  def business_params
    params.require(:business).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url)
  end
end
