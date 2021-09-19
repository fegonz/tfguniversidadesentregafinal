require 'nokogiri'
require 'open-uri'


class Uc3mSpider < Kimurai::Base
@name = 'uc3m_spider'
@engine = :mechanize
#grados
def self.process(url,universidad)

@start_urls = [url]

url=universidad.url


cosas = {}

self.parse!(:parse, url,universidad, cosas)



end


def parse_url(urlGrado,grado,data2)

  zanzo = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlGrado}`

  response2 = Nokogiri::HTML(zanzo)
  
  nombre =response2.xpath("//div[@class='contTitulo row']")
  nombre_grado = nombre.css("h1/text()")
  nombre_grado=nombre_grado.to_s
  grado.update(nombre: nombre_grado)
  response2.xpath("//div[@class='col span_12']").each do |tabla|
  
  curso=tabla.css('h2').text
  
  tabla.css("table").each do |proba|
  
  perro=proba.css("td[1]/a/text()")
    proba.css("tr").each do |asignatura|
    

        nombre_asignatura   = asignatura.css("td[1]/a/text()").to_s
        ects = asignatura.css("td[2]/text()").to_s



        if nombre_asignatura != "Trabajo Fin de Grado" && nombre_asignatura != "Optativas: Recomendado elegir 12 créditos" && nombre_asignatura.length > 1 
          
              if ects.length>0 
               
                  item2 = data2
                  
                  
                  item2[:nombre]      = nombre_asignatura 
                  item2[:creditos] = ects
                  tipo_asignatura      = asignatura.css("td[3]/text()").to_s

                  case tipo_asignatura
                  when  "O"
                       item2[:tipo]="Obligatoria"
                
                  when "FB"
                       item2[:tipo]="Formación básica"
                  when "P"
                       item2[:tipo]="Optativa"

                  when "O-P"
                        item2[:tipo]="Optativa Obligatoria"

                  end
                  item2[:grado]=grado
                  Asignatura.createAsignatura(item2)
                  

                   
                 
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


end


def parse(response, universidad, url, data: {})
 
 data = {}
 
 data_asignatura={}
 
 urlUc3m ="https://www.uc3m.es"
 
 paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.uc3m.es/grado/estudios`
  
 response = Nokogiri::HTML(paga)
   
 response.xpath("//div[@class='row marcoLiso conborde categoriaGrado']").each do |lista|
  
  
 
          lista.css("li/a/@href").each do |url2|
                    urlUc3mAux=urlUc3m
                    
                    urlUc3mAux=urlUc3mAux+url2
                    
                    item = data

                    item[:url] = urlUc3mAux.to_s
                    
                    item[:universidad] = universidad
                                   
                    grado = Grado.where(item).create
                                   
                    
                    
                    parse_url(urlUc3mAux,grado,data_asignatura)
          


          end

end
end

#finGrados

def self.processMaster(url,universidad)
    
     @start_urls = [url]
     
     idUniversidad=universidad.id
 
      cosas = {}
      self.parseMaster(idUniversidad,universidad, url, cosas)
      

     
   end
 
   
   
 
 def self.parse_urlMaster(urlMaster,master,data2)
 
      zanzo = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlMaster}`
    
      response2 = Nokogiri::HTML(zanzo)
      
      nombre =response2.xpath("//div[@class='contTitulo row']")
      nombre_master = nombre.css("h1/text()")
      nombre_master=nombre_master.to_s
      master.update(nombre: nombre_master)
      response2.xpath("//div[@class='col span_12']").each do |tabla|
      
      curso=tabla.css('h2').text
      
      tabla.css("table").each do |proba|
      
      perro=proba.css("td[1]/a/text()")
        proba.css("tr").each do |asignatura|
        
    
            nombre_asignatura   = asignatura.css("td[1]/a/text()").to_s
            ects = asignatura.css("td[2]/text()").to_s
    
    
    
            if nombre_asignatura != "Trabajo Fin de Grado" && nombre_asignatura != "Optativas: Recomendado elegir 12 créditos" && nombre_asignatura.length > 1 
              
                  if ects.length>0 
                   
                      item2 = data2
                      
 
                      item2[:master]      = master
                      item2[:curso]      = curso 
                      item2[:nombre]      = nombre_asignatura 
                      item2[:creditos] = ects
                      tipo_asignatura      = asignatura.css("td[3]/text()").to_s
    
                      case tipo_asignatura
                      when  "O"
                           item2[:tipo]="Obligatoria"
                    
                      when "FB"
                           item2[:tipo]="Formación básica"
                      when "P"
                           item2[:tipo]="Optativa"
    
                      when "O-P"
                            item2[:tipo]="Optativa Obligatoria"
    
                      end
                      
                      AsignaturaMaster.where(item2).create!
                      
    
                       
                     
                    end
                 
    
            end
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
    
     


end
    
    
def parseMaster(response2,idUniversidad, universidad, url, data: {})
     
     data = {}
     data_asignatura={}
     universidad= Universidad.find(idUniversidad.id)
     urlUc3m ="https://www.uc3m.es"
     
     paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.uc3m.es/postgrado/programas`
      
     response = Nokogiri::HTML(paga)
       
     response.xpath("//div[@class='row marcoLiso conborde categoriaGrado']").each do |lista|
      
      
     
              lista.css("li/a/@href").each do |url2|
                        urlUc3mAux=urlUc3m
                        
                        urlUc3mAux=urlUc3mAux+url2
                        
                        item = data
    
                        item[:url] = urlUc3mAux.to_s
                        
                        item[:universidad] = universidad
                            
                        master = Master.where(item).create!
                        
                        
                        
                        parse_urlMaster(urlUc3mAux,master,data_asignatura)
                        
    
    
              end
    
    end
    
  

end




