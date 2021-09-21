require 'nokogiri'
require 'open-uri'


class UpmSpider < Kimurai::Base

    @name = 'asignaturas_spider'
  @engine = :mechanize
  
  def self.process(url,universidad)
    
    @start_urls = [url]
    
    url=universidad.url
    
     cosas = {}
   
     
     self.parse!(:parse, url,universidad, cosas)
  end


                          
                         
                        
                                   

                       
      def parse_url(response2,data_asignatura,grado, urlgrado)
        url_parseable=urlgrado.to_s.gsub("&", "'&'")
        paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{url_parseable}`
        response = Nokogiri::HTML(paga)
       url_poli="https://www.upm.es"
       tabla=response.xpath("//div[@class='cuerpo']")
       
       tabla=tabla.css("table")
      
      contador=1
      tabla.css("tr").each do |tabla_grados|
        primera_columna=
        plan_de_estudios=tabla_grados.at("td[1]/text()")
       
        if plan_de_estudios.to_s =="Plan de Estudios"
         
        comprueba_pdf=tabla_grados.at("td[2]/a/@href")
        if comprueba_pdf.to_s.length==0
          comprueba_pdf=tabla_grados.at("td[2]/p[1]/a/@href")

        end
            
     
            url_pdf=url_poli+comprueba_pdf.to_s
             url_padf= url_pdf.to_s.gsub(" ", "%20")
            nombre_pdf= grado.nombre.gsub(" ", "")
            nombre_pdf=nombre_pdf.chop
            nombre=nombre_pdf+".pdf"
            
            ruta="../universidades/app/assets/pdf/"
            ruta_defi=ruta+nombre
            
            paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{url_padf} >#{ruta_defi} `

            
           
            
         
              sacar_asignaturas(grado, nombre)
              
            
          
        end
        
        

        
       end


      end
                      
                


           
              
         
      
      
      
      
   


 

  def parse(response, universidad, url, data: {})

    
   
       
       
       paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.upm.es/Estudiantes/Estudios_Titulaciones/EstudiosOficialesGrado`
       
       response = Nokogiri::HTML(paga)
       
       response.xpath("//div[@class='table-responsive']").each do |tabla_grados|
            
            
           
            tabla_grados.css("table").each do |tabla_individuales|
                
              tabla_individuales.css("td").each do |grado|
               nombre_grado= grado.css("a/strong/text()")
               urlgrado=grado.css("a/@href")

               item = data
               item[:url] = urlgrado
               item[:universidad] = universidad

               item = data
               item[:nombre]= nombre_grado.to_s
               item[:url] = urlgrado.to_s
               item[:universidad] = universidad
               if urlgrado.to_s.length< 300 &&(nombre_grado.length>0)
                grado = Grado.where(item).create!
               
               
                data_asignatura= {}
                parse_url(response,data_asignatura,grado, urlgrado)
                nombre_del_grado=grado.nombre
                universidad_del_grado=grado.universidad.id
                id_grado=grado.id
                grados= Grado.where(["nombre = :nombre and universidad_id = :universidad_id", { nombre: nombre_del_grado, universidad_id: universidad_del_grado }])

                if grados.count>1

                    grados.each do|grados_a_borrar|
                    id_del_grado=grados_a_borrar.id

                    if id_del_grado != id_grado
                          resultado2=Grado.destroy_by("id= ?", id_del_grado)

                    end

                end

end



               end
               
              
               
              end
        
         
    end

  end

end


def sacar_asignaturas(grado, nombre_pdf)
  
  ruta="../universidades/app/assets/pdf/" 
  ruta_buena=ruta+nombre_pdf

  reader = PDF::Reader.new(ruta_buena)

    

    
      reader.pages.each do |page|
    
      page.text.lines.each do |asignatura|
         contador_espacio_blanco=0
         nueva_palabra=false
         palabra=""
         palabras=[]
         contador_palabras=0
         contador=0
         
        tam=asignatura.length
        for i in (0..tam) do
          
          if asignatura[i]!=" "
          palabra=palabra+asignatura[i].to_s
          
          else
            contador=contador+1
            if contador>1
              palabras[contador_palabras]=palabra
              palabra=""
              contador_palabras=contador_palabras+1
             
              
            else
               contador = 0
            end
            contador=contador+1
          end
        
    end
    contador=0


   
    cod_asignatura=false
    creditos_bool=false
    nombre_asignatura=""
    creditos=""
    tip=""
    cod_asignatura=true
    palabras.each do |prem|
      
     
    if prem.length!=0
      
      if contador==0
       
        if prem.length==9 && (prem.start_with?( '1', '2', '3', '4', '5', '6', '7', '8', '9'))
           contador=1
           
        end
      end
        if contador==1 && (prem.start_with?( '1', '2', '3', '4', '5', '6', '7', '8', '9'))&&(cod_asignatura==false)
          creditos=prem
          contador=2
          cod_asignatura=true
          creditos_bool=true
       end
       if contador==1 &&(creditos_bool==false)&&(prem.start_with?( '1', '2', '3', '4', '5', '6', '7', '8', '9')==false)
        cod_asignatura=false
        nombre_asignatura=nombre_asignatura+" "+prem

       end
           
      if contador==2
        
        tipo=""
        case prem
                      when "Obl"
                           tipo="Obligatoria"
                           contador=4
                           
                    
                      when "Bás"
                           tipo="Formación básica"
                           contador=4
                      when "Opt"
                           tipo="Optativa"
                           contador=4
                
                      

                      end

                      if tipo.length==0
                          tipo="Optativa Itenerario"
                      end
                    


      end

      if contador==4
        contador=0
        #puts "Nombre "+ nombre_asignatura
        #puts "Creditos "+ creditos
        #puts "Tipo "+ tipo
        item2 = {}
                  
        item2[:nombre]      = nombre_asignatura 
        item2[:creditos] = creditos
        item2[:tipo]      = tipo
        item2[:grado] = grado
        asign=Asignatura.where(item2).create
        nombre_asignatura=""
        tipo=""
        creditos=""

       
        
        cod_asignatura=false
        

      end
     
    end


end
end

nombre_del_grado=grado.nombre
universidad_del_grado=grado.universidad.id
id_grado=grado.id
grados= Grado.where(["nombre = :nombre and universidad_id = :universidad_id", { nombre: nombre_del_grado, universidad_id: universidad_del_grado }])

if grados.count>1

     grados.each do|grados_a_borrar|
     id_del_grado=grados_a_borrar.id

     if id_del_grado != id_grado
          resultado2=Grado.destroy_by("id= ?", id_del_grado)

     end

end

end

  
end
end






end
