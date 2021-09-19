require 'nokogiri'
require 'open-uri'


class UahSpiderMaster < Kimurai::Base
    @name = 'asignaturas_spider'
    @engine = :mechanize
    
    def self.process(url,universidad)

        @start_urls = [url]
        
        url=universidad.url
        
        
        cosas = {}
        
        self.parse!(:parse, url,universidad, cosas)
        
        
        
        end
  
  
   
  
   
  
  
    def parse_url(urlMaster,master,data2)
  
  
      zanzo2 = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlMaster}`
                    
      response2 = Nokogiri::HTML(zanzo2)
    
      
   
      response2.xpath("//div[@class='panel panel-blue margin-bottom-40']").each do |tabla_cada_curso|          
       
        
        tipo=tabla_cada_curso.css('/div[@class="panel-heading"]/h3/text()')
      
        
      
      div_tabla= tabla_cada_curso.xpath("//div[@class='panel-body']")

      
    
     
       
       

      div_tabla.css("/table[@class='table table-striped table-bordered']/tbody/tr").each do |asignatura|
        
      nombre= asignatura.css("td[1]/a/text()")
      
      
      ects = asignatura.css("td[3]/text()")

      
      if tipo.to_s.exclude? "PROYECTO FIN DE" 
  
            item = data2                    
            item[:master]= master
            item[:nombre]= nombre.to_s
            item[:curso] = "No especificado"
            item[:creditos] = ects.to_s
            item[:tipo]      = tipo
                          
                                  
            AsignaturaMaster.where(item).create
      end
    end
                     
                            
                      
        
                      
    
        
    end
  
    nombre_del_master=master.nombre
    universidad_del_master=master.universidad.id
    id_master=master.id
    masters= Master.where(["nombre = :nombre and universidad_id = :universidad_id", { nombre: nombre_del_master, universidad_id: universidad_del_master }])

    if masters.count>1

         masters.each do|masters_a_borrar|
         id_del_master=masters_a_borrar.id

         if id_del_master != id_master
              resultado2=Master.destroy_by("id= ?", id_del_master)

         end

    end

    end

       
  
  
  
  
  
  
  
    end
    
  
    def parse(response, universidad, url, data: {})
        data_asignatura={}
  
  
       urlUalcala ="https://www.uah.es"
    
       paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.uah.es/es/estudios/estudios-oficiales/masteres-universitarios/`
         
       response = Nokogiri::HTML(paga)
       
       url_general= "https://www.uah.es/"
  
       response.xpath("//li[@class='simple only-title ']").each do |master|
       nombre_master = master.css("a/text()")
     
  
       master.css("a/@href").each do |enlace|
                    
       urlUah=urlUalcala+enlace
                    
                    
       zanzo = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlUah}`
                
                     
       url_master = Nokogiri::HTML(zanzo)
  
       cosas=url_master.xpath("//section[@id='planificacion-de-las-ensenanzas-y-profesorado-asignaturas-profesorado-competencias-guias-docentes-y-reglamento-del-trabajo-de-fin-de-master']")
       
       nombre_master=url_master.at("p[@class='pull-left miga']")

     

       cosas.css("ul/li/a/@href").each do |url_buena|
  
       my_url = "/es/masteres-universitarios/asignaturas/"
      
       
       if url_buena.to_s.include? my_url
                         url_con_asignaturas=url_buena.to_s

                         item = data

                         item[:url] = url_con_asignaturas.to_s
                         
                         item[:universidad] = universidad

                         item[:nombre] = nombre_master
                                        
                         master = Master.where(item).create
  
                         parse_url(url_con_asignaturas,master,data_asignatura)
  
                      end
  
  
                end
  
              end
  
        end

       
       
  
     
  
        
  end

end

