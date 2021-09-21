class UniversidadsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_universidad, only: %i[ show edit update destroy ]
  

  # GET /universidads or /universidads.json
  def index
    if current_user.has_role?(:admin)
    @universidads = Universidad.all
 
    else
      redirect_to root_path, alert: "No tienes permiso para esta accion"
    end
    
  end

  # GET /universidads/1 or /universidads/1.json
  def show
    if current_user.has_role?(:admin)
      @universidads = Universidad.all
    universidadId= params[:id]
    @grados= Grado.search :conditions => {:universidad_id => universidadId}
    grados2= @grados
    numAsignaturas=0
    grados2.each do |grado|
     asignaturas=devolver_numero_asignaturas(grado.id).count
     numAsignaturas=numAsignaturas+asignaturas

    end
    @numeroAsignaturas=numAsignaturas
  else
    redirect_to root_path, alert: "No tienes permiso para esta accion"
  end
    
  end
  def scrapeMaster

    
    universidad= Universidad.find(params[:idUniversidad])
    nombre_universidad= universidad.nombre

    url = universidad.url
    idUniversidad= universidad.id

    case nombre_universidad
    when "Universidad Carlos III de Madrid"
    
     
      response = Uc3mSpider.processMaster(url,universidad)
  
    when "Universidad Alfonso X el Sabio"
  
      response = UaxSpiderMaster.process(url,universidad)
    when "Universidad de Alcalá"
   
      response = UahSpiderMaster.process(url,universidad)

    when "Universidad Nebrija"
     
    when "Universidad Camilo José Cela"
   
      
    when "Universidad CEU San Pablo"

    when "Universidad Europea "

    when "Universidad Rey Juan Carlos"

    when "Universidad Complutense de Madrid"
      
    end
    

    gradosillos=Master.destroy_by("nombre= ?", "")

    gradosillos2=Master.destroy_by("nombre= ?", " ")
  
    asignatura=AsignaturaMaster.destroy_by("nombre= ?", "")
    asignatura=AsignaturaMaster.destroy_by("nombre= ?", " ")

    aga = `rake ts:rebuild`

    
    redirect_to universidads_path

  end

  def scrape
    
    universidad= Universidad.find(params[:idUniversidad])
    nombre_universidad= universidad.nombre
    
    url = universidad.url
    idUniversidad= universidad.id

    case nombre_universidad
    when "Universidad Carlos III de Madrid"

      response = Uc3mSpider.process(url,universidad)
    
  
    when "Universidad Alfonso X el Sabio"

      response = UaxSpider.process(url,universidad)
     

    when "Universidad de Alcalá"
      
      response = UahSpider.process(url,universidad)


    when "Universidad Nebrija"
      
      response = UnebrijaSpider.process(url,universidad)
    when "Universidad Camilo José Cela"
     
      response = UcamilojcSpider.process(url,universidad)
      
    when "Universidad CEU San Pablo"
     
      response = UceuSpider.process(url,universidad)
    when "Universidad Europea "
    
      response = UemSpider.process(url,universidad)
    when "Universidad Rey Juan Carlos"
     
      response = UrjcSpider.process(url,universidad)
    when "Universidad Politécnica de Madrid"
      
      response = UpmSpider.process(url,universidad)
    when "Universidad Complutense de Madrid"
      response = UcmSpider.process(url,universidad)
      
    end

    gradosillos=Grado.destroy_by("nombre= ?", "")

    gradosillos2=Grado.destroy_by("nombre= ?", " ")
  
    asignatura=Asignatura.destroy_by("nombre= ?", "")
    asignatura=Asignatura.destroy_by("nombre= ?", " ")

   
    aga = `rake ts:rebuild`
    
  
    
    redirect_to universidads_path

  end


  def borrar_grados_universidad(idUniversidad)
    resultado2=Grado.destroy_by("universidad_id= ?", idUniversidad)

  end

  def borrar_masters_universidad(idUniversidad)
    resultado=Master.destroy_by("universidad_id= ?", idUniversidad)

  end


  def borrar_grados_master_comunidad(idUniversidad)

      resultado2=Grado.destroy_by("universidad_id= ?", idUniversidad)
      resultado=Master.destroy_by("universidad_id= ?", idUniversidad)
  
     

  end

  def scrapear_comunidad
    if current_user.has_role?(:admin)
    comunidad= Comunidad.find(params[:idComunidad])

    comunidad_id=comunidad.id

    universidads= Universidad.where("comunidad_id= ?", comunidad_id)

    universidads.each do|universidad|

      idUniversidad=universidad.id
      universidad_nombre=universidad.nombre
      url = universidad.url
  

      case universidad_nombre
      when "Universidad Carlos III de Madrid"
  
        response = Uc3mSpider.process(url,universidad)
        response2 = Uc3mSpider.processMaster(url,universidad)
    
      when "Universidad Alfonso X el Sabio"
  
        response3 = UaxSpider.process(url,universidad)
        response4 = UaxSpiderMaster.process(url,universidad)
        
  
      when "Universidad de Alcalá"
        
        response5 = UahSpider.process(url,universidad)
        response6 = UahSpiderMaster.process(url,universidad)
  
      when "Universidad Nebrija"
        
        response7 = UnebrijaSpider.process(url,universidad)
      when "Universidad Camilo José Cela"
       
        response8 = UcamilojcSpider.process(url,universidad)
        
      when "Universidad CEU San Pablo"
       
        response9 = UceuSpider.process(url,universidad)
      when "Universidad Europea "
      
        response10 = UemSpider.process(url,universidad)
      when "Universidad Rey Juan Carlos"
       
        response11 = UrjcSpider.process(url,universidad)
      when "Universidad Politécnica de Madrid"
        
        response12 = UpmSpider.process(url,universidad)
      when "Universidad Complutense de Madrid"
        response = UcmSpider.process(url,universidad)
        
     
  
      end
  
      gradosillos=Grado.destroy_by("nombre= ?", "")
  
      gradosillos2=Grado.destroy_by("nombre= ?", " ")
    
      asignatura=Asignatura.destroy_by("nombre= ?", "")
      asignatura=Asignatura.destroy_by("nombre= ?", " ")



      
     
      aga = `rake ts:rebuild`
      
    
      
  

  

   
    end
    end

    redirect_to comunidads_path

  end
  

  # GET /universidads/new
  def new
    @universidad = Universidad.new
  end

  # GET /universidads/1/edit
  def edit
    authorize @universidad
  end

  # POST /universidads or /universidads.json
  def create
    @universidad = Universidad.new(universidad_params)

    respond_to do |format|
      if @universidad.save
        format.html { redirect_to @universidad, notice: "Universidad was successfully created." }
        format.json { render :show, status: :created, location: @universidad }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @universidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /universidads/1 or /universidads/1.json
  def update
    respond_to do |format|
      if @universidad.update(universidad_params)
        format.html { redirect_to @universidad, notice: "Universidad was successfully updated." }
        format.json { render :show, status: :ok, location: @universidad }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @universidad.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /universidads/1 or /universidads/1.json
  def destroy
    authorize @universidad
    @universidad.destroy
    respond_to do |format|
      format.html { redirect_to universidads_url, notice: "Universidad was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_universidad
      @universidad = Universidad.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def universidad_params
      params.require(:universidad).permit(:nombre, :tipo, :url, :comunidad_id)
    end
end
