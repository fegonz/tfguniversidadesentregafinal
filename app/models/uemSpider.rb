require 'nokogiri'
require 'open-uri'


class UemSpider < Kimurai::Base

    @name = 'uem_spider'
    @engine = :mechanize
    
    def self.process(url,universidad)

        @start_urls = [url]
        
        url=universidad.url
        
        
        cosas = {}
        
        self.parse!(:parse, url,universidad, cosas)
       
        
        
        end
  
    def parse_url(urlGrado,grado,data2)
  
  
  
        paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlGrado}`
         
        response = Nokogiri::HTML(paga)
  
        nombre_de_universidad='Universidad Europea'
    
        nombre_del_grado2=response.xpath("//div[@class='hero-banner-degree__text']")
  
        nombre_del_grado= nombre_del_grado2.css('h1/text()')

        nombre_grado=nombre_del_grado.to_s
        
        grado.update(nombre: nombre_grado)
        
        tablas_cursos=response.xpath("//div[@class='accordion-block__content']")
  
         
  
        
         tablas_cursos.css("table").each do |curso|
  
            curso_ano = curso.css("caption/text()")
            
            
            curso.css("tr").each do |asignatura|
  
  
                 nombre_asignatura= asignatura.css("td[2]/a/text()")
                 ects= asignatura.css("td[3]/text()")
                  tipo= asignatura.css("td[4]/text()")
                  
                  nombre_asignatura2= nombre_asignatura.to_s
                  nombre_asignatura2=nombre_asignatura2.downcase
                 if  nombre_asignatura2.exclude? 'trabajo fin de' 
                    if nombre_asignatura2.exclude? 'proyecto fin de'
  
                          if nombre_asignatura.to_s.length>1
                                item = data2
                  
                       
                                
                                item[:grado] = grado
                                item[:nombre]      = nombre_asignatura
                                #item[:curso] =  curso_ano
                                item[:creditos] = ects.to_s
                                item[:tipo]      = tipo.to_s
          
           
                               Asignatura.where(item).create
                          end     
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
        
        data = {}
        
        data_asignatura={}
        
        paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://universidadeuropea.com/grados-universitarios/?locations_filter=1%2C9`
         
        response = Nokogiri::HTML(paga)
        
        grados = response.xpath("//ul[@class='catalogue-study-list-componets__list-group']")
  
        grados.css("li/div/div/h3/a/@href").each do |url2|

            item = data

            item[:url] = url2.to_s
            
            item[:universidad] = universidad
                           
            grado = Grado.where(item).create
                           
            
            
            parse_url(url2,grado,data_asignatura)
  
        
        
       
       
  
       
     
  
      
      
    end
  
  
     
  
        
  
  
  
        
  
        
      
  end

end
