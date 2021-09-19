require 'nokogiri'
require 'open-uri'


class UcamilojcSpiderMaster < Kimurai::Base
    @name = 'uCamilo_spider'
    @engine = :mechanize
    
    def self.process(url,universidad)

        @start_urls = [url]
        
        url=universidad.url
        
        
        cosas = {}
        
        self.parse!(:parse, url,universidad, cosas)
        
        
        
    end
  
    def parse_url(urlMaster,master,data2)
  
     paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlMaster}`
         
     response = Nokogiri::HTML(paga)

    
     response.xpath("//div[@class='panel-collapse in']").each do |masters|
  
  
     urlGrado = urlGrado
  
  
       
        
       curso = "no facilitado"
  
       masters.css("table").each do |table|
        

  
            table.css("tr").each do |asignatura|
  
  
  
  
  
                 nombre= asignatura.css("td[1]/a/text()")
                 if nombre.to_s.length<1
                        nombre= asignatura.css("td[1]/text()")
                 end
                 if nombre.to_s.length>1
                            ects = asignatura.css("td[2]/text()")

                              nombre2=nombre.to_s
                              nombre2= nombre2.downcase
                       
  
                                   
  
  
                                          item = data2
                                          item[:master]      = master
                                          item[:curso]      = "No especificado"
                                          item[:tipo]      = "No especificado"
                                          item[:nombre]      = nombre.to_s
                                          #item[:curso] = curso.to_s
                                          item[:creditos] = ects.to_s
  
  
                                  
                                          
                                          AsignaturaMaster.where(item).create
       
                      
                       end
                end
                     
  
  
  
  
  
  
  
            end
  
         
     
  
      
      
    end
  
  
  
    end
  
  
    
    
  
    def parse(response, universidad, url, data: {})
       
       data = {}
       
       data_asignatura={}
  
       paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.ucjc.edu/postgrados/master-oficial/`
         
       response = Nokogiri::HTML(paga)
  
       
      
       response.xpath("//div[@class='ucjc-landing-grados-listado__blocks-item']").each do |master_especialidades|
       
        nombre_master= master_especialidades.css("a/h2/text()")
        
        master_especialidades.css("a/@href").each do |url2|
        
       
       
  
            item = data

            item[:url] = url2.to_s
            
            item[:universidad] = universidad
            item[:nombre] = nombre_master
                           
            master = Master.where(item).create
                           
            parse_url(url2,master,data_asignatura)
            
            
     
  
      end
      
    end
  
  
        
  
  
  
  
        
      
  end
   

end
