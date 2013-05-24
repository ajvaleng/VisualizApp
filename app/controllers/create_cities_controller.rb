class CreateCitiesController < ApplicationController
  # GET /create_cities
  # GET /create_cities.json
  def index
    #@create_cities = CreateCity.all
  @cities = CreateCity.all
  @json = @markets.to_gmaps4rails

    #respond_to do |format|
     # format.html # index.html.erb
      #format.json { render json: @create_cities }
    #end
  end

  # GET /create_cities/1
  # GET /create_cities/1.json
  def show
    @create_city = CreateCity.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @create_city }
    end
  end

  # GET /create_cities/new
  # GET /create_cities/new.json
  def new
    @create_city = CreateCity.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @create_city }
    end
  end

  # GET /create_cities/1/edit
  def edit
    @create_city = CreateCity.find(params[:id])
  end

  # POST /create_cities
  # POST /create_cities.json
  def create
    @create_city = CreateCity.new(params[:create_city])

    respond_to do |format|
      if @create_city.save
        format.html { redirect_to @create_city, notice: 'Create city was successfully created.' }
        format.json { render json: @create_city, status: :created, location: @create_city }
      else
        format.html { render action: "new" }
        format.json { render json: @create_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /create_cities/1
  # PUT /create_cities/1.json
  def update
    @create_city = CreateCity.find(params[:id])

    respond_to do |format|
      if @create_city.update_attributes(params[:create_city])
        format.html { redirect_to @create_city, notice: 'Create city was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @create_city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /create_cities/1
  # DELETE /create_cities/1.json
  def destroy
    @create_city = CreateCity.find(params[:id])
    @create_city.destroy

    respond_to do |format|
      format.html { redirect_to create_cities_url }
      format.json { head :no_content }
    end
  end
end
