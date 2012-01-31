json.array! @services do |json, service|
  json.id service.id
  json.title service.title
  json.url edit_path(:model_name => ActiveModel::Naming.plural(service), :id => service.id)
  json.updated_at service.updated_at
end
