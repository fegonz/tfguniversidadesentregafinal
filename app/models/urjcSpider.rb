require 'nokogiri'
require 'open-uri'


class UrjcSpider < Kimurai::Base

    @name = 'urjc_spider'
  @engine = :mechanize
  
  def self.process(url,universidad)
    
    @start_urls = [url]
   
    url=universidad.url
    
     cosas = {}
     
     self.parse!(:parse, url,universidad, cosas)
  end


  def grados_normales(response2,data,grado, urlUrjcAux)

      response3=response2.css("//div[@id='itinerario-formativo']")
       nombre =response2.xpath("//div[@class='itemHeader']")
      grado_name = nombre.css("h2/text()")
      nombre_grado=grado_name.to_s
      grado.update(nombre: nombre_grado)
      response3.css("table").each do |tabla|
             
             curso=tabla.css('tr[1]/td[1]/strong/text()')
              curso_comprueba = curso.to_s

               if curso_comprueba.length < 1 

               curso=tabla.css('tr[1]/td[1]/p/strong/text()')

             end



             tabla.css("tr").each do |asignatura|
             
                     
                     
                     semestre=asignatura.css('td[1]/p/text()')
                     curso_semestre=curso.to_s
                     nombre=asignatura.css('td[2]/p/text()')
                     tipo=asignatura.css('td[3]/p/text()')
                     creditos=asignatura.css('td[4]/p/text()')
                     
                



                     comprueba_semestre= semestre.to_s

                     if comprueba_semestre.length < 1 

                      semestre=asignatura.css('td[1]/text()')

                     end
              



                    comprueba_nombre= nombre.to_s

                     if comprueba_nombre.length < 1 

                          nombre=asignatura.css('td[2]/text()')

                     end
              




                    comprueba_tipo=  tipo.to_s

                     if comprueba_tipo.length < 1 

                       tipo=asignatura.css('td[3]/text()')

                     end

                     comprueba_creditos= creditos.to_s

                     if comprueba_creditos.length < 1 

                        creditos=asignatura.css('td[4]/text()')

                     end





                     item = data
                  
                  optativa="Optativa"
                    if nombre.to_s != optativa && nombre.to_s.length>2 && nombre != "Trabajo Fin de Grado"
                      

                              item = data

                                   
                              item[:grado]      = grado       
                              #item[:curso]      = curso_semestre.to_s
                              item[:nombre]      = nombre.to_s
                              item[:creditos] = creditos.to_s

                              case tipo.to_s


                                when  "FBR"
                                  item[:tipo] ="Formación Básica de Rama"
                                when  "FBC"
                                  item[:tipo] ="Formación Básica Común"
                                when  "OB"
                                  item[:tipo] ="Obligatoria"
                                when  "OP"
                                  item[:tipo] ="Optativa"
                                else
                                  item[:tipo] ="Por definir"

                                end
                       
                              Asignatura.where(item).create!
                        
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



  def grados_no_normales(response2,data,grado, urlUrjcAux)





   

      response_tecnicas2=response2.css("//div[@id='accordion-heading panel-heading']")
      response3=response2.css("//div[@id='itinerario-formativo']")
      nombre =response2.xpath("//div[@class='itemHeader']")
      grado_name = nombre.css("h2/text()")
      nombre_grado=grado_name.to_s
      grado.update(nombre: nombre_grado)
      response3.css("table").each do |tabla|
      curso=tabla.css('tr[1]/td[1]/strong/text()')
      curso_comprueba = curso.to_s

               if curso_comprueba.length < 1 

               curso=tabla.css('tr[1]/td[1]/p/strong/text()')

             end



             tabla.css("tr").each do |asignatura|
             
                    
                    


                     semestre=asignatura.css('td[1]/p/text()')
                     curso_semestre=curso.to_s
                     nombre=asignatura.css('td[2]/p/text()')
                     tipo=asignatura.css('td[4]/p/text()')
                     creditos=asignatura.css('td[5]/p/text()')
                     
                 


                     comprueba_semestre= semestre.to_s

                     if comprueba_semestre.length < 1 

                      semestre=asignatura.css('td[1]/text()')

                     end
              



                    comprueba_nombre= nombre.to_s

                     if comprueba_nombre.length < 1 

                          nombre=asignatura.css('td[2]/text()')

                     end
              




                    comprueba_tipo=  tipo.to_s

                     if comprueba_tipo.length < 1 

                       tipo=asignatura.css('td[3]/text()')

                     end

                     comprueba_creditos= creditos.to_s

                     if comprueba_creditos.length < 1 

                        creditos=asignatura.css('td[4]/text()')

                     end


                    optativa="optativa"

                    nombre_contiene= nombre.to_s
                    nombre_contiene= nombre_contiene.downcase()

                    
                    
                      if nombre.to_s != optativa && nombre.to_s.length>1 && nombre != "Trabajo Fin de Grado"

                              item = data
                              
                              
                              item[:grado]      = grado
                              #item[:curso]      = curso_semestre.to_s 
                              item[:nombre]      = nombre.to_s 
                              item[:creditos] = creditos.to_s 
                                   

                              case tipo.to_s


                                when  "FBR"
                                  item[:tipo] ="Formación Básica de Rama"
                                when  "FBC"
                                  item[:tipo] ="Formación Básica Común"
                                when  "OB"
                                  item[:tipo] ="Obligatoria"
                                when  "OP"
                                  item[:tipo] ="Optativa"
                                else
                                  item[:tipo] ="Optativa"

                                end
                      
                       
                              Asignatura.where(item).create!
                       
                      
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




 

  def parse(response, universidad, url, data: {})

       
   
       urlUrjc="https://www.urjc.es"
       
       paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.urjc.es/estudios/grado`
       
       response = Nokogiri::HTML(paga)
       
       response.xpath("//div[@class='accordion-group panel rl_sliders-group nn_sliders-group']").each do |lista|
            
            
           
            lista.css("li/a/@href").each do |url2|
                urlUrjcAux=urlUrjc
               
                urlUrjcAux=urlUrjc+url2

                zanzo = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlUrjcAux}`
           
               response2 = Nokogiri::HTML(zanzo)
       
               response2.xpath("//div[@class='accordion-body rl_sliders-body nn_sliders-body in collapse']")

               response_tecnicas=response2.css("//a[@data-id='plan-de-estudios']")
          
               plan= response_tecnicas.css("a/span/text()")
          
               pland=plan.to_s
               
               plan_grados_no_normales=" Plan de Estudios"
               
               item = data
               item[:url] = urlUrjcAux.to_s
               item[:universidad] = universidad
                  
               
               grado = Grado.where(item).create!
              
               data_asignatura= {}
               
               if pland==plan_grados_no_normales

                      

                      grados_no_normales(response2,data_asignatura,grado, urlUrjcAux)


               else

                      grados_normales(response2,data_asignatura,grado, urlUrjcAux)

               end
        
         
    end

  end

  paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.urjc.es/estudios/doble-grado`
       
  response = Nokogiri::HTML(paga)
  
  response.xpath("//div[@class='accordion-group panel rl_sliders-group nn_sliders-group']").each do |lista|
       
       
      
       lista.css("li/a/@href").each do |url2|
           urlUrjcAux=urlUrjc
          
           urlUrjcAux=urlUrjc+url2

           zanzo = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlUrjcAux}`
      
          response2 = Nokogiri::HTML(zanzo)
  
          response2.xpath("//div[@class='accordion-body rl_sliders-body nn_sliders-body in collapse']")

          response_tecnicas=response2.css("//a[@data-id='plan-de-estudios']")
     
          plan= response_tecnicas.css("a/span/text()")
     
          pland=plan.to_s
          
          plan_grados_no_normales=" Plan de Estudios"
          
          item = data
          item[:url] = urlUrjcAux.to_s
          item[:universidad] = universidad
             
          
          grado = Grado.where(item).create!

          
         
          data_asignatura= {}
          
          if pland==plan_grados_no_normales

                 

                 grados_no_normales(response2,data_asignatura,grado, urlUrjcAux)


          else

                 grados_normales(response2,data_asignatura,grado, urlUrjcAux)

          end
   
    
end

end

end

end