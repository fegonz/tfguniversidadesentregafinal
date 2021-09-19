class ApplicationController < ActionController::Base
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def devolver_numero_asignaturas(grado_id)
   
       @asignaturas= Asignatura.search :conditions => {:grado_id=> grado_id}
       return @asignaturas
    end 
    helper_method :devolver_numero_asignaturas

    def devolver_numero_grados(universidad_id)
   
      @grados= Grado.search :conditions => {:universidad_id=> universidad_id}
      return @grados
   end 
   helper_method :devolver_numero_grados

   def devolver_numero_masters(universidad_id)
   
    @masters= Master.search :conditions => {:universidad_id=> universidad_id}
    return @masters
    end 
    helper_method :devolver_numero_masters



   def devolver_numero_universidades_comunidad(comunidad_id)
   
      @universidades= Universidad.where(["comunidad_id = :comunidad_id", { comunidad_id: comunidad_id }])
      return @universidades
   end 
   helper_method :devolver_numero_universidades_comunidad


   def devolver_numero_grados_comunidad(comunidad_id)
   
    universidades= Universidad.where(["comunidad_id = :comunidad_id", { comunidad_id: comunidad_id }])
         
    numGrados=0

    universidades.each do |universidad|

      grados=Grado.where(["universidad_id = :universidad_id", { universidad_id: universidad.id }])
      numGrados= numGrados+grados.count


    end
    @num_Grados= numGrados


    return @num_Grados
   end 
   helper_method :devolver_numero_grados_comunidad


   def devolver_numero_grados_comunidad(comunidad_id)
   
    universidades= Universidad.where(["comunidad_id = :comunidad_id", { comunidad_id: comunidad_id }])
         
    numGrados=0

    universidades.each do |universidad|

      grados=Grado.where(["universidad_id = :universidad_id", { universidad_id: universidad.id }])
      numGrados= numGrados+grados.count


    end
    @num_Grados= numGrados


    return @num_Grados
   end 
   helper_method :devolver_numero_grados_comunidad


   def devolver_numero_masters_comunidad(comunidad_id)
   
    universidades= Universidad.where(["comunidad_id = :comunidad_id", { comunidad_id: comunidad_id }])
         
    numMasters=0

    universidades.each do |universidad|

      masters=Master.where(["universidad_id = :universidad_id", { universidad_id: universidad.id }])
      numMasters= numMasters+masters.count


    end
    @num_Masters= numMasters


    return @num_Masters
   end 
   helper_method :devolver_numero_masters_comunidad

   

    private
  
    def user_not_authorized #pundit_gema
      flash[:alert] = "No estás autorizado para esta acción."
      redirect_to(request.referrer || root_path)
    end
    
end


