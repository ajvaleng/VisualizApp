class DataFilesController < ApplicationController
  # GET /data_files
  # GET /data_files.json
  def index
    @data_files = current_user.data_files

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @data_files }
    end
  end

  # GET /data_files/1
  # GET /data_files/1.json
  def show
    @data_file = DataFile.find(params[:id])

    if @data_file.has_acces(current_user)
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @data_file }
      end
    else
      flash[:error] = "No tiene acceso a esa informacion"
      redirect_to data_files_path
    end
  end

  # GET /data_files/new
  # GET /data_files/new.json
  def new
    @data_file = DataFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @data_file }
    end
  end

  # GET /data_files/1/edit
  def edit
    @data_file = DataFile.find(params[:id])
  end

  # POST /data_files
  # POST /data_files.json
  def create
    @data_file = DataFile.new(params[:data_file])

    respond_to do |format|
      if @data_file.save
        format.html { redirect_to @data_file, notice: 'Data file was successfully created.' }
        format.json { render json: @data_file, status: :created, location: @data_file }
      else
        format.html { render action: "new" }
        format.json { render json: @data_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /data_files/1
  # PUT /data_files/1.json
  def update
    @data_file = DataFile.find(params[:id])

    respond_to do |format|
      if @data_file.update_attributes(params[:data_file])
        format.html { redirect_to @data_file, notice: 'Data file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @data_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /data_files/1
  # DELETE /data_files/1.json
  def destroy
    @data_file = DataFile.find(params[:id])
    @data_file.destroy

    respond_to do |format|
      format.html { redirect_to data_files_url }
      format.json { head :no_content }
    end
  end
end
