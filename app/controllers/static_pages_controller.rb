class StaticPagesController < ApplicationController
  def index
    
   
    
    
    
  end

  def buscador
    
    
   
    
  end

  def buscadorG
    
    @universidades = Universidad.all
   
    
  end

  def buscadorM
    
    @universidades = Universidad.all
   
    
  end

  def buscadorGrado
    @universidades = Universidad.all
    pub = params[:publica_privada]

    
    @asignaturas=[]
    
    if (defined? params[:nombre])
      
      @nombre_asig = params[:nombre]
      nombre_asigna = params[:nombre]
    
      asignaturas= Asignatura.search  :conditions => {:nombre => nombre_asigna}
    
    if pub!=""

      asignaturas.each do|asignatura|

        universidad_asignatura=asignatura.grado.universidad.id
   
        if universidad_asignatura.to_s== pub.to_s

          @asignaturas.push(asignatura)

        end

       end

       
    else
      @asignaturas=asignaturas

    end

    end
    
    
    
  end


  def buscadorMaster

    pub = params[:publica_privada]
     @universidades = Universidad.all
    @asignaturasMaster=[]
    if (defined? params[:nombre])
      
      @nombre_asig = params[:nombre]
      nombre_asigna = params[:nombre]
     
      asignaturasMaster= AsignaturaMaster.search :conditions => {:nombre => nombre_asigna}


      if pub!=""

        asignaturasMaster.each do|asignatura|
  
          universidad_asignatura=asignatura.master.universidad.id
     
          if universidad_asignatura.to_s== pub.to_s
  
            @asignaturasMaster.push(asignatura)
  
          end
  
         end
  
         
      else
        @asignaturasMaster=asignaturasMaster
  
      end
  
    end
    
    
    
  end
end
