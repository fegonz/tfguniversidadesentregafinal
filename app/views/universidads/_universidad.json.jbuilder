json.extract! universidad, :id, :nombre, :tipo, :url, :comunidad_id, :created_at, :updated_at
json.url universidad_url(universidad, format: :json)
