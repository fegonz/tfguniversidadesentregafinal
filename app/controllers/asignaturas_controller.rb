class AsignaturasController < ApplicationController
  before_action :authenticate_user!
  before_action :set_asignatura, only: %i[ show edit update destroy ]

  # GET /asignaturas or /asignaturas.json
  def index
    if current_user.has_role?(:admin)
      @asignaturas= Asignatura.search(:per_page => 100000)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /asignaturas/1 or /asignaturas/1.json
  def show
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /asignaturas/new
  def new
    if current_user.has_role?(:admin)
    @asignatura = Asignatura.new
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /asignaturas/1/edit
  def edit
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # POST /asignaturas or /asignaturas.json
  def create
    if current_user.has_role?(:admin)
      @asignatura = Asignatura.new(asignatura_params)

      respond_to do |format|
        if @asignatura.save
          format.html { redirect_to @asignatura, notice: "Asignatura was successfully created." }
          format.json { render :show, status: :created, location: @asignatura }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @asignatura.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # PATCH/PUT /asignaturas/1 or /asignaturas/1.json
  def update
    if current_user.has_role?(:admin)
        respond_to do |format|
          if @asignatura.update(asignatura_params)
            format.html { redirect_to @asignatura, notice: "Asignatura was successfully updated." }
            format.json { render :show, status: :ok, location: @asignatura }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @asignatura.errors, status: :unprocessable_entity }
          end
        end
      else
        redirect_to root_path, alert: "No tienes permiso para esta accion"
      end
  end

  # DELETE /asignaturas/1 or /asignaturas/1.json
  def destroy
    if current_user.has_role?(:admin)
      @asignatura.destroy
      respond_to do |format|
        format.html { redirect_to asignaturas_url, notice: "Asignatura was successfully destroyed." }
        format.json { head :no_content }
      end
    
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_asignatura
      @asignatura = Asignatura.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def asignatura_params
      params.require(:asignatura).permit(:nombre, :tipo, :creditos, :grado_id)
    end
end
