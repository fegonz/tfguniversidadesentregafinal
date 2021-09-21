require 'nokogiri'
require 'open-uri'
require 'pdf/reader'

class UcmSpider < Kimurai::Base
@name = 'UCM_spider'
@engine = :mechanize

def self.process(url,universidad)

@start_urls = [url]

url=universidad.url

 cosas = {}
 self.parse!(:parse, url, universidad, cosas)

end



def parse(response, universidad, url, data: {})#url, data: {})
 

  prueba="https://www.ucm.es/estudios/grado"
  prueba=prueba.gsub("&", "'&'")


  paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"  #{prueba}`
   
   response = Nokogiri::HTML(paga)



 tabla_asignaturas=response.xpath("//div")
 

  centros_adscritos=false
  tabla_asignaturas.css("ul[@class='menu_pag']").each do |listas_tipos_grados|
  
  listas_tipos_grados.css("li").each do |lista|
   
    

    if centros_adscritos==false

      url_grado=lista.css("a/@href").to_s

    nombre_grado=lista.css("a/text()")
    nombre_grado=nombre_grado.to_s
    
    item = {}

    item[:url] = url_grado.to_s
    
    item[:nombre] = nombre_grado.to_s
    item[:universidad] = universidad
                   
    grado = Grado.where(item).create!

    

    parse_pdf(grado)
    nombre_del_grado=grado.nombre
    universidad_del_grado=grado.universidad.id
    grados= Grado.where(["nombre = :nombre and universidad_id = :universidad_id", { nombre: nombre_del_grado, universidad_id: universidad_del_grado }])
      id_grado=grado.id
    if grados.count>1
    
         grados.each do|grados_a_borrar|
         id_del_grado=grados_a_borrar.id
    
         if id_del_grado != id_grado
              resultado2=Grado.destroy_by("id= ?", id_del_grado)
    
         end
    
    end
    
    end

    end



    if nombre_grado.to_s=="Grado en Turismo"
         centros_adscritos=true

    end
    

  end
  
end
end

def parse_pdf(grado)
  paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)"  #{grado.url}`
    
  response = Nokogiri::HTML(paga)
  url="https://www.ucm.es"
  tabla_asignaturas=response.xpath("//div[@class='est_izq']")



  tabla_asignaturas.css("ul[@class='menu_est']").each do |diptico|
     
      pdf=diptico.css("li[@class='pdf']/a/@href")
      pdf_descarga=url+pdf.to_s
      grado_nombre=grado.nombre.gsub(" ", "")
      grado_nombre=grado_nombre.gsub(")", "")
      grado_nombre=grado_nombre.gsub("(", "")
    
      grado_nombre="ucm"+grado_nombre+".pdf"
     
      ruta_descarga="../universidades/app/assets/pdf/"+grado_nombre.to_s
    
      if pdf.to_s.length==0
        id_grado=grado.id
        Grado.destroy(id_grado)
      else
      paga = `curl --user-agent "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)" #{pdf_descarga} >#{ruta_descarga} `
      sacar_asignaturas(grado,ruta_descarga)
      end
  end
end

def sacar_asignaturas(grado, nombre_pdf)


     contador = 0

   
   
   
    

      contador = contador + 1
        
      print "CONTADOR : "
      puts contador

      #reader = PDF::Reader.new("2313.pdf")
      reader = PDF::Reader.new(nombre_pdf)

      palabras = reader.pages[0].text.lines.map(&:chomp)


      texto = Array.new palabras.size()
      texto[0] = palabras[0].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
      @nombre_grado = ""
      @curso_actual = ""
      @nombre_universidad = ""
      for palabra in texto[0]
        
        @nombre_grado = @nombre_grado + palabra + " "
      end



      i = 3
      texto[i] = palabras[i].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")

      while i < palabras.size()-1 && texto[i] != ""  do
        
        texto[i] = palabras[i].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
        
        for palabra in texto[i]
          
          @nombre_grado = @nombre_grado + palabra + " "
        end
        i = i + 1
      end

      print "nombre_grado : "
      puts @nombre_grado

      texto[i] = palabras[i].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
      for palabra in texto[i]
          
          @nombre_universidad = @nombre_universidad + palabra + " "
        end

      print "nombre_universidad : "
      puts @nombre_universidad
      #buscar linea normal
      #contar espacios delante
      #eliminar lineas sin ese numero de espacios (por mitades)(mas adelante en el bucle main)



      #puts palabras.size()
      #p palabras.inspect
      #palabras[j][0, 61].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
      palabras = reader.pages[1].text.lines.map(&:chomp)
      basura = Array.new palabras.size()
      j = 0
      contador_cursos = 0

      #podar basura
      while (contador_cursos < 2 && j < palabras.size()) do
        #puts palabras
        if (palabras != nil && palabras != "")
          if (palabras[j] != nil && palabras[j] != "")
            basura[j] = palabras[j][0, 51].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")

            
            if (basura[j][1] == "Curso" || basura[j][basura[j].size() -1] == "ECTS") then
              
              contador_cursos = contador_cursos + 1
              if contador_cursos == 2 then
                @curso_actual = ""
                for palabra in basura[j][0, basura[j].size() - 1]
              
                  @curso_actual = @curso_actual + palabra + " "
                end
              end
            end
          end
        end
        j = j + 1
      end
      j = j - 1


      @asignaturas = Array.new palabras.size() * 2
      primera_mitad = Array.new palabras.size() * 2
      i = 0
      puts palabras
      palabras.size()
      if @curso_actual == nil || @curso_actual == "" || @curso_actual == " "
        @curso_actual = "Primer Curso"
      end
      while j < palabras.size()  do
        
        
        #palabras[j].delete(1..3) #delete_if!.with_index{|element,index| index >= 1 && index <= 3}
        creditos = 0
        if(palabras[j][0, 51] != nil && palabras[j][0, 51] != "")
          primera_mitad[j] = palabras[j][0, 59].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
          if(primera_mitad[j] != nil && primera_mitad[j] != [])
            
            nombre_asignatura = ""

            @creditos = primera_mitad[j][primera_mitad[j].size()-1]
            @ultima_letra = primera_mitad[j][primera_mitad[j].size()-1][primera_mitad[j][primera_mitad[j].size()-1].size()-1]
            
            begin
              
              creditos = @creditos.to_i
              ultima_letra = @ultima_letra.to_i

            rescue MyCustomException => e
              puts "EXCEPCION : "
              puts e.message
              creditos = 0
              ultima_letra = 0
            end
          end
          if (primera_mitad[j].size() == 0) then
            

            elsif (primera_mitad[j][primera_mitad[j].size()-1] == "ECTS")
              
              tu = primera_mitad[j].size()-1
              @curso_actual = ""
              for palabra in primera_mitad[j][0, tu]
              @curso_actual = @curso_actual + palabra + " "
            end

            puts "CURSO_ACTUAL : " << @curso_actual
          elsif (primera_mitad[j][0] == "") 
          elsif (primera_mitad[j] == nil) 
          elsif (primera_mitad[j][0] == "*") 
          
            if(j >= palabras.size()-1)
              j = j + 1
            end
            while (j < palabras.size()-1 && (primera_mitad[j][1] != "Curso" || primera_mitad[j][primera_mitad[j].size() -1] != "ECTS" )) do
              j = j + 1
              primera_mitad[j] = palabras[j][0, 61].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
            end

            j = j - 1
          elsif (palabras[j][2]  != " ")
          elsif(creditos > 0 && creditos <= 50) 
            nombre_asignatura = ""
            if(primera_mitad[j].size() == 1)

              #@asignaturas[i][1] = creditos
              
            elsif(creditos <= 18)
              if(@asignaturas[i] != nil)
                nombre_asignatura = @asignaturas[i][0] 
                for palabra in primera_mitad[j][0, primera_mitad[j].size()-1]

                  nombre_asignatura = nombre_asignatura + palabra + " "
                end
                asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
                @asignaturas[i] = asignatura
              else
                 

                for palabra in primera_mitad[j][0, primera_mitad[j].size()-1]
                  nombre_asignatura = nombre_asignatura + palabra + " "
                end

                asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
                @asignaturas[i] = asignatura
              end

            end
            
            i = i + 1
          elsif (ultima_letra > 0 && creditos <= 50)
            if(ultima_letra <= 18)
              if(@asignaturas[i] != nil)
                nombre_asignatura = @asignaturas[i][0] 
              else
                nombre_asignatura = ""
              end
                for palabra in primera_mitad[j][0, primera_mitad[j].size()-1]

                  nombre_asignatura = nombre_asignatura + palabra + " "
                end
              asignatura = [nombre_asignatura, ultima_letra, @curso_actual,@nombre_grado, @nombre_universidad]
              @asignaturas[i] = asignatura
              i = i + 1
            end
          else #Cuando la asignatura está en varias lineas / lina sin creditos
            puede_anterior = false
            puede_siguiente = false
            es_siguiente = false
            es_anterior = false

            if(palabras[j-1][0, 51] != nil && palabras[j-1][0, 51] != "")
              if ((primera_mitad[j-1].size() != 0  && primera_mitad[j][primera_mitad[j].size()-1] != "ECTS" )|| primera_mitad[j][0] != "*") 

                @creditos = primera_mitad[j-1][primera_mitad[j-1].size()-1]
                begin
                  
                  creditos = @creditos.to_i
                  
                rescue MyCustomException => e
                  puts "EXCEPCION : "
                  puts e.message
                  creditos = 0
                end

                if (j < palabras.size())
                  if(creditos > 0 && creditos <= 18)
                    if primera_mitad[j-1].size() == 1
                      es_anterior = true
                    elsif(palabras[j-1][0, 51] != nil && palabras[j-1][0, 51] != "")
                      contador_digitos = 3  
                      for palabra in primera_mitad[j-1][0, primera_mitad.size()]
                        contador_digitos = contador_digitos + palabra.size() + 1
                      end

                      if(contador_digitos + primera_mitad[j][0].size() >= 44)
                        puede_anterior = true
                      end
                    end
                  
                    
                  end
                  
                end
              end
            end
            if (j < palabras.size()-1 && palabras[j+1] != nil && palabras[j+1][0, 51] != nil && palabras[j+1][0, 51] != "")
              
              siguiente = palabras[j+1][0, 61].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
              if siguiente[siguiente.size()-1] != "ECTS" 
                if(i == 0)
                  es_siguiente = true
                end
                if (siguiente.size() != 0 && siguiente[siguiente.size()-1] != "ECTS" || siguiente[0] != "*") 
                  creditos = siguiente[siguiente.size()-1]
                  begin
                    creditos = creditos.to_i
                  rescue MyCustomException => e
                    puts "EXCEPCION : "
                    puts e.message
                    creditos = 0
                  end
                  if(creditos > 0 && creditos <= 18)

                    if(palabras[j-1][0, 51] == nil || palabras[j-1][0, 51] == "" )
                      es_siguiente = true

                    elsif(siguiente.size() == 1)
                      es_siguiente = true
                    else
                      contador_digitos = 3  
                      for palabra in primera_mitad[j]
                        contador_digitos = contador_digitos + palabra.size() + 1
                      end

                      if(contador_digitos + siguiente[0].size() >= 44)
                        puede_siguiente = true
                      end
                    end
                  end
                end
              end
            end
            if(es_siguiente)
              creditos = 0
              nombre_asignatura = ""
              for palabra in primera_mitad[j]
                nombre_asignatura = nombre_asignatura + palabra + " "
              end
              asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
              @asignaturas[i] = asignatura
            elsif es_anterior 
              for palabra in primera_mitad[j]
                @asignaturas[i-1][0] = @asignaturas[i-1][0] + palabra + " "
              end
            elsif(puede_siguiente && !puede_anterior)
              creditos = 0
              nombre_asignatura = ""
              for palabra in primera_mitad[j]
                nombre_asignatura = nombre_asignatura + palabra + " "
              end
              asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
              @asignaturas[i] = asignatura
            elsif(!puede_siguiente && puede_anterior)
              for palabra in primera_mitad[j]
                @asignaturas[i-1][0] = @asignaturas[i-1][0] + palabra + " "
              end
            else 
              creditos = 0
              nombre_asignatura = ""
              for palabra in primera_mitad[j]
                nombre_asignatura = nombre_asignatura + palabra + " "
              end
              asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]

              @asignaturas[i] = asignatura
              #puts asignatura
            end
          end
        end
        j = j + 1
      end
















    primera_mitad = Array.new palabras.size() * 2
    j = 0

    contador_cursos = 0

      #podar basura
      while (contador_cursos < 1 && j < palabras.size()) do
        #puts palabras
        if (palabras[j] != nil && palabras[j] != "")
          if (palabras[j][59, 110] != nil && palabras[j][59, 110] != "")
            basura[j] = palabras[j][59, 110].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")

            
            if (basura[j][basura[j].size() -1] == "ECTS") then

              contador_cursos = contador_cursos + 1
              if contador_cursos == 1 then
                @curso_actual = ""
                for palabra in basura[j][0, basura[j].size() - 1]
              
                  @curso_actual = @curso_actual + palabra + " "
                end
              end
            end
          end
        end
        j = j + 1
      end
      #j = j - 1

    while j < palabras.size()  do
        
        
        #palabras[j].delete(1..3) #delete_if!.with_index{|element,index| index >= 1 && index <= 3}
        creditos = 0
        if(palabras[j][59, 110] != nil && palabras[j][59, 110] != "")
          primera_mitad[j] = palabras[j][59, 110].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
          if(primera_mitad[j] != nil && primera_mitad[j] != [])
            
            nombre_asignatura = ""

            @creditos = primera_mitad[j][primera_mitad[j].size()-1]
            @ultima_letra = primera_mitad[j][primera_mitad[j].size()-1][primera_mitad[j][primera_mitad[j].size()-1].size()-1]
            
            begin
              
              creditos = @creditos.to_i
              ultima_letra = @ultima_letra.to_i

            rescue MyCustomException => e
              puts "EXCEPCION : "
              puts e.message
              creditos = 0
              ultima_letra = 0
            end
          end
          if (primera_mitad[j].size() == 0) then

            elsif (primera_mitad[j][primera_mitad[j].size()-1] == "ECTS")
              
              tu = primera_mitad[j].size()-1
              @curso_actual = ""
              for palabra in primera_mitad[j][0, tu]
              @curso_actual = @curso_actual + palabra + " "
            end
          elsif (primera_mitad[j][0] == "") 
          elsif (primera_mitad[j] == nil) 
          elsif (primera_mitad[j][0] == "*") 
          
            if(j >= palabras.size()-1)
              j = j + 1
            end
            while (j < palabras.size()-1 && (primera_mitad[j][1] != "Curso" || primera_mitad[j][primera_mitad[j].size() -1] != "ECTS" )) do
              j = j + 1
              while(palabras[j][59, 110] == nil || palabras[j][59, 110] == "")
                j = j + 1
              end
                primera_mitad[j] = palabras[j][59, 110].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
              
            end

            j = j - 1
          elsif (palabras[j][59]  != " ")
          elsif(creditos > 0 && creditos <= 50) 
            nombre_asignatura = ""
            if(primera_mitad[j].size() == 1)
              if(@asignaturas[i] == nil)
                asignatura = ["", creditos, @curso_actual,@nombre_grado, @nombre_universidad]
                @asignaturas[i] = asignatura
              else
              
                @asignaturas[i][1] = creditos
              end
              
            elsif(creditos <= 18)
              if(@asignaturas[i] != nil)
                nombre_asignatura = @asignaturas[i][0] 
                for palabra in primera_mitad[j][0, primera_mitad[j].size()-1]

                  nombre_asignatura = nombre_asignatura + palabra + " "
                end
                asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
                @asignaturas[i] = asignatura
              else
                 

                for palabra in primera_mitad[j][0, primera_mitad[j].size()-1]
                  nombre_asignatura = nombre_asignatura + palabra + " "
                end

                asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
                @asignaturas[i] = asignatura
              end

            end
            
            i = i + 1
          elsif (ultima_letra > 0 && creditos <= 50)
            if(ultima_letra <= 18)
              if(@asignaturas[i] != nil)
                nombre_asignatura = @asignaturas[i][0] 
              else
                nombre_asignatura = ""
              end
                for palabra in primera_mitad[j][0, primera_mitad[j].size()-1]

                  nombre_asignatura = nombre_asignatura + palabra + " "
                end
              asignatura = [nombre_asignatura, ultima_letra, @curso_actual,@nombre_grado, @nombre_universidad]
              @asignaturas[i] = asignatura
              i = i + 1
            end
          else #Cuando la asignatura está en varias lineas / lina sin creditos
            puede_anterior = false
            puede_siguiente = false
            es_siguiente = false
            es_anterior = false

            if(palabras[j-1][59, 110] != nil && palabras[j-1][59, 110] != "" && primera_mitad[j-1] != nil)
              if (primera_mitad[j-1].size() != 0  && primera_mitad[j][primera_mitad[j].size()-1] != "ECTS" && primera_mitad[j][0] != "*") 

                @creditos = primera_mitad[j-1][primera_mitad[j-1].size()-1]
                begin
                  
                  creditos = @creditos.to_i
                  
                rescue MyCustomException => e
                  puts "EXCEPCION : "
                  puts e.message
                  creditos = 0
                end

                if (j < palabras.size())
                  if(creditos > 0 && creditos <= 18)
                    if primera_mitad[j-1].size() == 1
                      es_anterior = true
                    elsif(palabras[j-1][59, 110] != nil && palabras[j-1][59, 110] != "")
                      contador_digitos = 2 
                      for palabra in primera_mitad[j-1][0, primera_mitad.size()]
                        contador_digitos = contador_digitos + palabra.size() + 1
                      end

                      if(contador_digitos + primera_mitad[j][0].size() >= 44)
                        puede_anterior = true
                      end
                    end
                  
                    
                  end
                  
                end
              end
            end
            if (j < palabras.size()-1 && palabras[j+1] != nil && palabras[j+1][59, 110] != nil && palabras[j+1][59, 110] != "")
              
              siguiente = palabras[j+1][59, 110].gsub(/\s+/m, ' ').gsub(/^\s+|\s+$/m, '').split(" ")
              if siguiente[siguiente.size()-1] != "ECTS" 
                if(i == 0)
                  es_siguiente = true
                end
                if (siguiente.size() != 0 && siguiente[siguiente.size()-1] != "ECTS" || siguiente[0] != "*") 
                  creditos = siguiente[siguiente.size()-1]
                  begin
                    creditos = creditos.to_i
                  rescue MyCustomException => e
                    puts "EXCEPCION : "
                    puts e.message
                    creditos = 0
                  end
                  if(creditos > 0 && creditos <= 18)

                    if(palabras[j-1][59, 110] == nil || palabras[j-1][59, 110] == "" )
                      es_siguiente = true

                    elsif(siguiente.size() == 1)
                      es_siguiente = true
                    else
                      contador_digitos = 2
                      for palabra in primera_mitad[j]
                        contador_digitos = contador_digitos + palabra.size() + 1
                      end

                      if(contador_digitos + siguiente[0].size() >= 44)
                        puede_siguiente = true
                      end
                    end
                  end
                end
              end
            end
            if(es_siguiente)
              creditos = 0
              nombre_asignatura = ""
              for palabra in primera_mitad[j]
                nombre_asignatura = nombre_asignatura + palabra + " "
              end
              asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
              @asignaturas[i] = asignatura
            elsif es_anterior 
              for palabra in primera_mitad[j]
                @asignaturas[i-1][0] = @asignaturas[i-1][0] + palabra + " "
              end
            elsif(puede_siguiente && !puede_anterior)
              creditos = 0
              nombre_asignatura = ""
              for palabra in primera_mitad[j]
                nombre_asignatura = nombre_asignatura + palabra + " "
              end
              asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]
              @asignaturas[i] = asignatura
            elsif(!puede_siguiente && puede_anterior)
              for palabra in primera_mitad[j]
                @asignaturas[i-1][0] = @asignaturas[i-1][0] + palabra + " "
              end
            else 
              creditos = 0
              nombre_asignatura = ""
              for palabra in primera_mitad[j]
                nombre_asignatura = nombre_asignatura + palabra + " "
              end
              asignatura = [nombre_asignatura, creditos, @curso_actual,@nombre_grado, @nombre_universidad]

              @asignaturas[i] = asignatura
              
            end
          end
        end
        j = j + 1
      end

      for palabra in @asignaturas
        if palabra
          print palabra
          puts ""
          item2 = {}
              
          item2[:nombre]      = palabra[0]
          item2[:creditos] = palabra[1]
          item2[:tipo]      = ""
          #item2[:curso] = palabra[2]
          item2[:grado] = grado
          asign=Asignatura.where(item2).create!

        end
      end


      #puts @asignaturas
    

    



end




end



