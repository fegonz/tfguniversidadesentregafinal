class ComunidadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comunidad, only: %i[ show edit update destroy ]

  # GET /comunidads or /comunidads.json
  def index
    if current_user.has_role?(:admin)
      @comunidads = Comunidad.all
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /comunidads/1 or /comunidads/1.json
  def show
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  def borrar_grados_y_masteres

    comunidad= Comunidad.find(params[:idComunidad])
    
    universidades=Universidad.where("comunidad_id= ?", comunidad)

    universidades.each do|universidad|

      resultado2=Grado.destroy_by("universidad_id= ?", universidad.id)
     resultado=Master.destroy_by("universidad_id= ?", universidad.id)

    end
    aga = `rake ts:rebuild`
    redirect_to root_path

  end

  # GET /comunidads/new
  def new
    if current_user.has_role?(:admin)
      @comunidad = Comunidad.new
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /comunidads/1/edit
  def edit
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # POST /comunidads or /comunidads.json
  def create
    if current_user.has_role?(:admin)
        @comunidad = Comunidad.new(comunidad_params)

        respond_to do |format|
          if @comunidad.save
            format.html { redirect_to @comunidad, notice: "Comunidad was successfully created." }
            format.json { render :show, status: :created, location: @comunidad }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @comunidad.errors, status: :unprocessable_entity }
          end
        end
      else
        redirect_to root_path, alert: "No tienes permiso para esta accion"
      end
  end

  # PATCH/PUT /comunidads/1 or /comunidads/1.json
  def update
    if current_user.has_role?(:admin)
      respond_to do |format|
        if @comunidad.update(comunidad_params)
          format.html { redirect_to @comunidad, notice: "Comunidad was successfully updated." }
          format.json { render :show, status: :ok, location: @comunidad }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @comunidad.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # DELETE /comunidads/1 or /comunidads/1.json
  def destroy
    if current_user.has_role?(:admin)
      @comunidad.destroy
      respond_to do |format|
        format.html { redirect_to comunidads_url, notice: "Comunidad was successfully destroyed." }
        format.json { head :no_content }
      end
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comunidad
      @comunidad = Comunidad.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comunidad_params
      params.require(:comunidad).permit(:nombre)
    end
end
