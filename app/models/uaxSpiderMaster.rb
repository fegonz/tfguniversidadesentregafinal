require 'nokogiri'
require 'open-uri'


class UaxSpiderMaster < Kimurai::Base

    @name = 'uax_spider'
  @engine = :mechanize
  
 

def self.process(url,universidad)
    
  @start_urls = [url]
 
  

  url=universidad.url


  cosas = {}
  
 self.parse!(:parse, url,universidad, cosas)
  
end







def parse_url(urlMaster,master,data)


   paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlMaster}`
     
      response = Nokogiri::HTML(paga)

    
    nombre_del_master=response.at('//h1/text()')
    nombre_del_master=nombre_del_master.to_s
    
    master.update(nombre: nombre_del_master)

    
    
     tablas_cursos=response.xpath("//div[@class='wysiwyg dropdown__content studies-plan']")

     #curso_numero=1
     tablas_cursos.css("table").each do |curso|
  
     #if curso_numero==1
      #  cursillo= response.at('//p[@class="studies-plan__title"][1]/text()').to_html
     #end

     #if curso_numero==2
      #  cursillo= response.at('//p[@class="studies-plan__title"][2]/text()').to_html
     #end

     #if curso_numero==3
      #  cursillo= response.at('//p[@class="studies-plan__title"][3]/text()').to_html
     #end

     #if curso_numero==4
      #  cursillo= response.at('//p[@class="studies-plan__title"][4]/text()').to_html
     #end
     
     
     

         curso.css("tr").each do |asignatura|

        
          nombre = asignatura.css("td[2]/a/text()")
          tipo = asignatura.css("td[3]/text()")
          ects = asignatura.css("td[4]")
        
          ects = asignatura.css("td[4]/strong")
      
          ects = asignatura.css("td[4]/strong/text()")
        
          if ects.length<1
            ects = asignatura.css("td[4]/text()")
          
          end

          if nombre.to_s.length>1
            if nombre.to_s!= "Trabajo Fin de Grado" && nombre.to_s != "Optativa"


                item2 = data

                
               
                puts "Premio " +ects.to_s
                item2[:nombre]      = nombre
                item2[:master]      = master
                #item[:curso]      = "por definir"
                item2[:creditos] = ects.to_s
                item2[:tipo]      = tipo.to_s
                
                AsignaturaMaster.where(item2).create!
            
          
            end
          end  



         end

     #curso_numero=1+curso_numero
     


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

   
  urlUax ="https://www.uax.com"

    paginas=1

    while paginas<4


      paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.uax.com/masters-y-postgrados?page=#{paginas}`
      paginas=paginas+1
      response = Nokogiri::HTML(paga)


  
     response.xpath("//div[@class='card card--program swiper-slide']").each do |lista|
      
      
     
      lista.css("a/@href").each do |url2|
      urlUaxAux=urlUax
     
      urlUaxAux=urlUaxAux+url2
      item = data
      item[:url] = urlUaxAux.to_s
                  
      item[:universidad] = universidad
                     
      master = Master.where(item).create!
      data_asignatura={}
     
      parse_url(urlUaxAux,master,data_asignatura)



     
    
    

    end
    

   
     
  end
  
end


 

    
end





 

end

