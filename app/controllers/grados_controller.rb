class GradosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_grado, only: %i[ show edit update destroy ]

  # GET /grados or /grados.json
  def index
    if current_user.has_role?(:admin)
    @grados = Grado.search(:per_page => 100000)
    else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # GET /grados/1 or /grados/1.json
  def show
    if current_user.has_role?(:admin)
      @grados = Grado.search
    gradoId= params[:id]
    @asignaturas= Asignatura.search :conditions => {:grado_id => gradoId}
   
  
  else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
  end
    
  end

  # GET /grados/new
  def new
    if current_user.has_role?(:admin)
        @grado = Grado.new
      else
        redirect_to root_path, alert: "No tienes permiso para esta accion"
      end
  end

  # GET /grados/1/edit
  def edit
    if current_user.has_role?(:admin)
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  # POST /grados or /grados.json
  def create
    if current_user.has_role?(:admin)
      @grado = Grado.new(grado_params)

      respond_to do |format|
        if @grado.save
          format.html { redirect_to @grado, notice: "Grado was successfully created." }
          format.json { render :show, status: :created, location: @grado }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @grado.errors, status: :unprocessable_entity }
        end
      end
  else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
  end
  end

  # PATCH/PUT /grados/1 or /grados/1.json
  def update
    if current_user.has_role?(:admin)
        respond_to do |format|
          if @grado.update(grado_params)
            format.html { redirect_to @grado, notice: "Grado was successfully updated." }
            format.json { render :show, status: :ok, location: @grado }
          else
            format.html { render :edit, status: :unprocessable_entity }
            format.json { render json: @grado.errors, status: :unprocessable_entity }
          end
        end
  else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
  end
  end

  def borrar_grados
    if current_user.has_role?(:admin)
      idUniversidad= params[:idUniversidad]
      
      grados=Grado.destroy_by("universidad_id = ?", idUniversidad)

      redirect_to universidads_path
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
  end

  end

  # DELETE /grados/1 or /grados/1.json
  def destroy
    if current_user.has_role?(:admin)
        @grado.destroy
        respond_to do |format|
          format.html { redirect_to grados_url, notice: "Grado was successfully destroyed." }
          format.json { head :no_content }
        end
    else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_grado
      @grado = Grado.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def grado_params
      params.require(:grado).permit(:nombre, :url, :universidad_id)
    end
end
