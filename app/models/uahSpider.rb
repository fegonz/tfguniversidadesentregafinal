require 'nokogiri'
require 'open-uri'


class UahSpider < Kimurai::Base
    @name = 'asignaturas_spider'
    @engine = :mechanize
    
    def self.process(url,universidad)

        @start_urls = [url]
        
        url=universidad.url
        
        
        cosas = {}
        
        self.parse!(:parse, url,universidad, cosas)
        
        
        
        end
  
  
   
  
   
  
  
    def parse_url(urlGrado,grado,data2)
  
  
      zanzo2 = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlGrado}`
                    
      response2 = Nokogiri::HTML(zanzo2)
  
      prueba=response2.xpath("//div[@class='wrapper wrapper-box']")
  
      nombre_grado=prueba.css('header/hgroup/h2/text()')

      nombre_grado=nombre_grado.to_s
      
      grado.update(nombre: nombre_grado)
  
      response2.xpath("//div[@class='panel panel-blue margin-bottom-40']").each do |tabla_cada_curso|
                    
      curso=tabla_cada_curso.css('/div/h3/text()')
                   
      response2.css("//div/table[@class='table table-striped table-bordered']").each do |tabla_cada_cuatrimestre|
                      
      tabla_cada_cuatrimestre.css("/tbody/tr").each do |asignatura|
                              
      nombre= asignatura.css("td[1]/a/text()")
      
      ects = asignatura.css("td[4]/text()")
      
      tipo  = asignatura.css("td[5]/text()")
                            
      tipo_cuatrimestre= tipo.to_s
  
  
      if tipo_cuatrimestre == "1er CUATRIMESTRE" || tipo_cuatrimestre == "2º CUATRIMESTRE"
  
        tipo= "Optativa"
  
      end
  
  
      if tipo.to_s != "PROYECTO FIN DE CARRERA"
  
            item = data2                    
            item[:grado]= grado
            item[:nombre]= nombre 
            #item[:curso] = curso
            item[:creditos] = ects
            item[:tipo]      = tipo
                          
                                  
            asignatura=Asignatura.where(item).create

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
    
  
    def parse(response, universidad, url, data: {})
        data_asignatura={}
  
  
       urlUalcala ="https://www.uah.es"
    
       paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.uah.es/es/estudios/estudios-oficiales/grados/`
         
       response = Nokogiri::HTML(paga)
       
       url_general= "https://www.uah.es/"
  
       response.xpath("//li[@class='simple only-title ']").each do |grado|
  
       grado.css("a/@href").each do |enlace|
                    
       urlUah=urlUalcala+enlace
                    
                    
       zanzo = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlUah}`
                
                     
       url_grados = Nokogiri::HTML(zanzo)
  
       cosas=url_grados.xpath("//section[@id='planificacion-de-la-ensenanza-asignaturas--horarios--examenes']")
  
       cosas.css("ul/li/a/@href").each do |url_buena|
  
       my_url = "es/estudios/estudios-oficiales/grados/asignaturas/"
  
  
       if url_buena.to_s.include? my_url
                         url_con_asignaturas=urlUalcala+url_buena.to_s

                         item = data

                         item[:url] = url_con_asignaturas.to_s
                         
                         item[:universidad] = universidad
                                        
                         grado = Grado.where(item).create
  
                         parse_url(url_con_asignaturas,grado,data_asignatura)
  
                      end
  
  
                end
  
              end
  
        end
  
       
  
     
  
        
  end

end

