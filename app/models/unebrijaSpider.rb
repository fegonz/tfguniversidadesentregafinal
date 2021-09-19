
require 'nokogiri'
require 'open-uri'


class UnebrijaSpider < Kimurai::Base

    @name = 'unebrija_spider'
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

    nombre_del_grado2=response.xpath("//section[@id='oferta-academica']")

    nombre_del_grado= nombre_del_grado2.css('h2/text()')
    
    nombre_grado=nombre_del_grado.to_s
    
    grado.update(nombre: nombre_grado)
      
    tablas_cursos=response.xpath("//div[@class='col-md-6 d-flex flex-column']")


    tablas_cursos.css("div[@class='panel panel-default']").each do |curso|

        curso_ano = curso.css("h4/a/text()")

        asignatura= curso.css("li/text()").each do |nombre_asignatura|

              if nombre_asignatura.to_s != "Trabajo Fin de Grado" || (nombre_asignatura.to_s != "Proyecto Fin de Grado" )

                 item = data2
                
                     
                 
                  item[:grado] = grado
                  item[:nombre]      = nombre_asignatura.to_s
                  #item[:curso]      = curso_ano
                  item[:creditos] = "Consultar universidad"
                  item[:tipo]      = "Consultar Universidad"
        
         
                Asignatura.where(item).create

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

    paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" https://www.nebrija.com/lp/2021/grado/marca/?Cod_TipoFRM=2039&gclsrc=aw.ds&ds_rl=1291044`
       
    response = Nokogiri::HTML(paga)

    response.xpath("//div[@class='content-oferta']").each do |grados_especialidades|
       
        grados_especialidades.css("li/a/@href").each do |url2|
      
        item = data

        item[:url] = url2.to_s
        
        item[:universidad] = universidad
                       
        grado = Grado.where(item).create
                       
        
        
        parse_url(url2,grado,data_asignatura)
   

    end
    
  end

      
    
end
 

end