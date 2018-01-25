class AlliancesController < ApplicationController
  def index
    scope = Alliance.all.approved
    if params[:search]
      @alliances = scope.where('name ILIKE ?', "%#{params[:search]}%")
    elsif params[:category_search]
      @alliances = scope.where(area_of_interest_id: params[:category_search])
    elsif params[:region_search]
      @alliances = scope.where(region_id: params[:region_search])
    else
      @alliances = scope
    end
    render layout: "landing_page"
  end

  def show
    @alliance = Alliance.find(params[:id])
    @charitable_donation = @alliance.charitable_donations.new donation_amount: 20
    render layout: "landing_page"
  end

  def edit
    @alliance = Alliance.find(params[:id])
    authorize @alliance
    render layout: "form_page"
  end

  def update
    @alliance = Alliance.find(params[:id])
    authorize @alliance
    if @alliance.update_attributes(alliance_params)
     flash[:success] = "Alliance Updated!"
     redirect_to @alliance
    else
      render 'edit'
    end
  end

  private
  def alliance_params
    params.require(:alliance).permit(:contact_email, :name, :description, :region_id, :logo, :church_category_id, :website_url, :facebook_url, :twitter_url, :gplus_url)
  end
end
