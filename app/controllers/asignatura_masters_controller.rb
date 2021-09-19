class AsignaturaMastersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_asignatura_master, only: %i[ show edit update destroy ]

  # GET /asignatura_masters or /asignatura_masters.json
  def index
    if current_user.has_role?(:admin)
      @asignatura_masters = AsignaturaMaster.search(:per_page => 100000)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /asignatura_masters/1 or /asignatura_masters/1.json
  def show
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /asignatura_masters/new
  def new
    if current_user.has_role?(:admin)
      @asignatura_master = AsignaturaMaster.new
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /asignatura_masters/1/edit
  def edit
    if current_user.has_role?(:admin)

    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # POST /asignatura_masters or /asignatura_masters.json
  def create
    if current_user.has_role?(:admin)
      @asignatura_master = AsignaturaMaster.new(asignatura_master_params)

      respond_to do |format|
        if @asignatura_master.save
          format.html { redirect_to @asignatura_master, notice: "Asignatura master was successfully created." }
          format.json { render :show, status: :created, location: @asignatura_master }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @asignatura_master.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # PATCH/PUT /asignatura_masters/1 or /asignatura_masters/1.json
  def update
    if current_user.has_role?(:admin)
      respond_to do |format|
        if @asignatura_master.update(asignatura_master_params)
          format.html { redirect_to @asignatura_master, notice: "Asignatura master was successfully updated." }
          format.json { render :show, status: :ok, location: @asignatura_master }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @asignatura_master.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # DELETE /asignatura_masters/1 or /asignatura_masters/1.json
  def destroy
    if current_user.has_role?(:admin)
      @asignatura_master.destroy
      respond_to do |format|
        format.html { redirect_to asignatura_masters_url, notice: "Asignatura master was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asignatura_master
      @asignatura_master = AsignaturaMaster.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def asignatura_master_params
      params.require(:asignatura_master).permit(:nombre, :curso, :tipo, :creditos, :master_id)
    end
end
