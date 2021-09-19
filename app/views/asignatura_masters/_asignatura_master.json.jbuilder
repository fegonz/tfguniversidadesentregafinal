json.extract! asignatura_master, :id, :nombre, :curso, :tipo, :creditos, :master_id, :created_at, :updated_at
json.url asignatura_master_url(asignatura_master, format: :json)
