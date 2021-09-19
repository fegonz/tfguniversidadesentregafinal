class MastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_master, only: %i[ show edit update destroy ]

  # GET /masters or /masters.json
  def index
    if current_user.has_role?(:admin)
    @masters = Master.search(:per_page => 100000)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /masters/1 or /masters/1.json
  def show
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /masters/new
  def new
    if current_user.has_role?(:admin)
    @master = Master.new
    else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /masters/1/edit
  def edit
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # POST /masters or /masters.json
  def create
    if current_user.has_role?(:admin)
    @master = Master.new(master_params)

    respond_to do |format|
      if @master.save
        format.html { redirect_to @master, notice: "Master was successfully created." }
        format.json { render :show, status: :created, location: @master }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @master.errors, status: :unprocessable_entity }
      end
    end
  else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
  end
  end

  # PATCH/PUT /masters/1 or /masters/1.json
  def update
    if current_user.has_role?(:admin)
    respond_to do |format|
      if @master.update(master_params)
        format.html { redirect_to @master, notice: "Master was successfully updated." }
        format.json { render :show, status: :ok, location: @master }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @master.errors, status: :unprocessable_entity }
      end
    end
  else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
  end
  end

  def borrar_masters
    if current_user.has_role?(:admin)
      idUniversidad= params[:idUniversidad]
      
      master=Master.destroy_by("universidad_id = ?", idUniversidad)

      redirect_to universidads_path
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
  end

  end

  # DELETE /masters/1 or /masters/1.json
  def destroy
    if current_user.has_role?(:admin)
    @master.destroy
    respond_to do |format|
      format.html { redirect_to masters_url, notice: "Master was successfully destroyed." }
      format.json { head :no_content }
    end
  else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
  end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_master
      @master = Master.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def master_params
      params.require(:master).permit(:nombre, :url, :universidad_id)
    end
end
