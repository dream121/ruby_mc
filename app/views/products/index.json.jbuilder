json.array!(@products) do |product|
  json.extract! product, :id, :name, :price, :kind, :course_id
  json.url product_url(product, format: :json)
end
