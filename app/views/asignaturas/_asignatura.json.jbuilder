json.extract! asignatura, :id, :nombre, :tipo, :creditos, :grado_id, :created_at, :updated_at
json.url asignatura_url(asignatura, format: :json)
