require 'nokogiri'
require 'open-uri'


class UcamilojcSpider < Kimurai::Base
    @name = 'uCamilo_spider'
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
     
     nombre_grado=response.xpath("//div[@class='c-hero-v2__left--main-title u-text--title-medium-large js-theme-font']/text()")

     nombre_grado=nombre_grado.to_s
     grado.update(nombre: nombre_grado)
    
     response.xpath("//div[@class='panel-collapse in']").each do |grados|
  
  
     urlGrado = urlGrado
  
  
       
        
       curso = "no facilitado"
       contador = 1
        grados.css("table").each do |table|
        
             if contador == 1
              
              curso = grados.at('//a[@class="c-tabs__plan-tab c-tabs__plan--tab-active"][1]/text()')
             
  
            end
  
  
            if contador == 2
  
              curso= grados.at('//a[@class="c-tabs__plan-tab"][1]/text()')
  
            end
  
  
            if contador == 3
  
              curso= grados.at('//a[@class="c-tabs__plan-tab"][2]/text()')
  
            end
  
  
            if contador == 4
  
              curso= grados.at('//a[@class="c-tabs__plan-tab"][3]/text()')
  
            end
  
  
            if contador == 5
  
              curso= grados.at('//a[@class="c-tabs__plan-tab"][4]/text()')
  
            end
  
  
            if contador == 6
  
              curso= grados.at('//a[@class="c-tabs__plan-tab"][5]/text()')
  
            end
  
  
            
  
            table.css("tr").each do |asignatura|
  
  
  
  
  
                 nombre= asignatura.css("td[1]/a/text()")
                 if nombre.to_s.length<1
                        nombre= asignatura.css("td[1]/text()")
                 end
                 if nombre.to_s.length>1
                        if curso =="ITINERARIO"
                          curso = asignatura.css("td[2]/text()")
                          ects = asignatura.css("td[3]/text()")
                          tipo  = asignatura.css("td[4]/text()")

                        else
                         
                          ects = asignatura.css("td[2]/text()")
                          tipo  = asignatura.css("td[3]/text()")
                        
                        end
                            
  
                            tipo2= tipo.to_s.downcase
  
  
                           
                              tipo2=tipo2.downcase
                              nombre2=nombre.to_s
                              nombre2= nombre2.downcase
                              curso2=curso.to_s
                              curso2= curso2.downcase
  
                            if tipo2.exclude? 'tfg' 
  
                                  if tipo2.exclude? 'tipo'
                                      if nombre2.exclude? 'grado'
  
                                        if nombre2.exclude? "optativas"
  
                                        if  curso2.exclude? "menciones"
                                   
  
  
                                          item = data2
                                          item[:grado]      = grado

                                          item[:nombre]      = nombre.to_s
                                          #item[:curso] = curso.to_s
                                          item[:creditos] = ects.to_s
  
                                          case tipo.to_s
                                                  when  "B"
                                                       item[:tipo]="Formación Básica"
                                                
                                                  when "0B"
                                                       item[:tipo]="Obligatorias"
  
                                                  when "OB"
                                                       item[:tipo]="Obligatorias"
                                                  when "PE"
                                                       item[:tipo]="Prácticas Externas"
  
                                                  when "OP"
                                                        item[:tipo]="Optativas"
                                                        item[:nombre]      = "Optativa"
  
                                                  else
                                                   item[:tipo] = tipo
  
                                            end
  
                                  
                                          
                                          Asignatura.where(item).create
                                end
                              end
                            end
                          end
                        end
                     
                            
                      
                       
                    
                       
                      
                       end
                end
                      contador=contador +1
  
  
  
  
  
  
  
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
  
       paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.ucjc.edu/estudios-universitarios/grados/oficiales/`
         
       response = Nokogiri::HTML(paga)
  
  
      
       response.xpath("//div[@class='ucjc-landing-grados-listado__blocks-item']").each do |grados_especialidades|
 
        grados_especialidades.css("a/@href").each do |url2|
        
       
       
  
            item = data

            item[:url] = url2.to_s
            
            item[:universidad] = universidad
                           
            grado = Grado.where(item).create
                           
            
            
            parse_url(url2,grado,data_asignatura)
     
  
      end
      
    end
  
  
        
  
  
  
  
        
      
  end
   

end
