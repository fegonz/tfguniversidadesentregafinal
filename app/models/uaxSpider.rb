require 'nokogiri'
require 'open-uri'


class UaxSpider < Kimurai::Base

    @name = 'uax_spider'
  @engine = :mechanize
  
  def self.process(url,universidad)
    
    @start_urls = [url]
   
    

    url=universidad.url


    cosas = {}
    
    self.parse!(:parse, url,universidad, cosas)
    
  end


 

 


  def parse_url(urlGrado,grado,data)


     paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{urlGrado}`
       
        response = Nokogiri::HTML(paga)

      
      nombre_del_grado=response.at('//h1/text()')
      nombre_del_grado=nombre_del_grado.to_s 
      grado.update(nombre: nombre_del_grado)
      
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
            ects = asignatura.css("td[4]/text()")


            if nombre.to_s.length>1
              if nombre.to_s!= "Trabajo Fin de Grado" && nombre.to_s != "Optativa"


                  item = data

                  
                  item[:grado] = grado
                  
                  item[:nombre]      = nombre
                  #item[:curso]      = "por definir"
                  item[:creditos] = ects
                  item[:tipo]      = tipo
        
         
                Asignatura.where(item).create
              
            
              end
            end  



           end

       #curso_numero=1+curso_numero
       


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

     
    urlUax ="https://www.uax.com"

      paginas=1

      while paginas<6


        paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.uax.com/grados?page=#{paginas}`
        paginas=paginas+1
        response = Nokogiri::HTML(paga)


    
       response.xpath("//div[@class='card card--program swiper-slide']").each do |lista|
        
        
       
        lista.css("a/@href").each do |url2|
        urlUaxAux=urlUax
       
        urlUaxAux=urlUaxAux+url2
        item = data
        item[:url] = urlUaxAux.to_s
                    
        item[:universidad] = universidad
                       
        grado = Grado.where(item).create
        data_asignatura={}
        parse_url(urlUaxAux,grado,data_asignatura)



       
      
      

      end
      

     
       
    end
    
  end


   

      
end
 

end

