class ChurchesController < ApplicationController
  def index
    scope = Church.all.approved
    if params[:search]
      @churches = scope.where('name ILIKE ?', "%#{params[:search]}%")
    elsif params[:category_search]
      @churches = scope.where(church_category_id: params[:category_search])
    elsif params[:region_search]
      @churches = scope.where(region_id: params[:region_search])
    else
      @churches = scope
    end
    render layout: "landing_page"
  end

  def show
    @church = Church.find(params[:id])
    @charitable_donation = @church.charitable_donations.new donation_amount: 20
    render layout: "landing_page"
  end

  def edit
    @church = Church.find(params[:id])
    authorize @church
    render layout: "form_page"
  end

  def update
    @church = Church.find(params[:id])
    authorize @church
    if @church.update_attributes(church_params)
     flash[:success] = "Church Updated!"
     redirect_to @church
    else
      render 'edit'
    end
  end

  private
  def church_params
    params.require(:church).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url)
  end
end
