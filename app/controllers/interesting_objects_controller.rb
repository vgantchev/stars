class InterestingObjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_interesting_object, only: [:show, :edit, :update, :destroy, :rate, :estimate_value]
  before_action :check_owner, only: [:edit, :update, :destroy]

  # GET /interesting_objects
  # GET /interesting_objects.json
  def index
    @interesting_objects = InterestingObject.all
  end

  # GET /interesting_objects/1
  # GET /interesting_objects/1.json
  def show
    # Needed to prefill the rating stars
    @user_rating = @interesting_object.ratings.find_by(user: current_user).try(:score) || 0
    @user_value_estimate = @interesting_object.value_estimates.find_by(user: current_user).try(:value)

    respond_to do |format|
      format.html { render :show }
      format.json { render json: @interesting_object.as_json, status: :ok }
    end
  end

  # GET /interesting_objects/new
  def new
    @interesting_object = InterestingObject.new
  end

  # GET /interesting_objects/1/edit
  def edit
  end

  # POST /interesting_objects
  # POST /interesting_objects.json
  def create
    @interesting_object = InterestingObject.new(interesting_object_params)
    @interesting_object.user = current_user

    respond_to do |format|
      if @interesting_object.save
        format.html { redirect_to @interesting_object, notice: 'Interesting object was successfully created.' }
        format.json { render :show, status: :created, location: @interesting_object }
      else
        format.html { render :new }
        format.json { render json: @interesting_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /interesting_objects/1
  # PATCH/PUT /interesting_objects/1.json
  def update
    respond_to do |format|
      if @interesting_object.update(interesting_object_params)
        format.html { redirect_to @interesting_object, notice: 'Interesting object was successfully updated.' }
        format.json { render :show, status: :ok, location: @interesting_object }
      else
        format.html { render :edit }
        format.json { render json: @interesting_object.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /interesting_objects/1
  # DELETE /interesting_objects/1.json
  def destroy
    @interesting_object.destroy
    respond_to do |format|
      format.html { redirect_to interesting_objects_url, notice: 'Interesting object was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /interesting_objects/:id
  def rate
    rating = @interesting_object.ratings.find_by(user: current_user)

    if rating
      rating.assign_attributes(rate_params)
    else
      rating = @interesting_object.ratings.new(rate_params)
      rating.user = current_user
    end

    respond_to do |format|
      if rating.save
        format.html { redirect_to @interesting_object, notice: 'Thank you for rating.' }
        format.json { render json: { msg: 'Thank you for rating.' }, status: :ok }
      else
        format.html { redirect_to @interesting_object, fast_alert: 'Your rating could not be saved.' }
        format.json { render json: { errors: rating.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def estimate_value
    value_estimate = @interesting_object.value_estimates.find_by(user: current_user)

    if value_estimate
      value_estimate.assign_attributes(value_estimate_params)
    else
      value_estimate = @interesting_object.value_estimates.new(value_estimate_params)
      value_estimate.user = current_user
    end

    respond_to do |format|
      if value_estimate.save
        format.html { redirect_to @interesting_object, notice: 'Thank you for estimating the value.' }
        format.json { render json: { msg: 'Thank you for estimating.' }, status: :ok }
      else
        format.html { redirect_to @interesting_object, fast_alert: 'Your value estimate could not be saved.' }
        format.json { render json: { errors: value_estimate.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_interesting_object
      @interesting_object = InterestingObject.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def interesting_object_params
      params.require(:interesting_object).permit(:name, :description, :photo)
    end

    def rate_params
      params.permit(:score)
    end

    def value_estimate_params
      params.permit(:value)
    end

    def check_owner
      return redirect_to interesting_objects_path, fast_alert: "Only object owners can perform this action." unless current_user == @interesting_object.user
    end
end
