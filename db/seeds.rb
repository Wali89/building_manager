# Clear existing data
puts "Clearing existing data..."
CustomFieldValue.destroy_all
Building.destroy_all
CustomField.destroy_all
Client.destroy_all

# Create clients
puts "Creating clients..."
clients = [
  { name: "Skyscraper Specialists" },
  { name: "Green Home Builders" },
  { name: "Historic Renovations Inc." },
  { name: "Modern Office Designs" },
  { name: "Cozy Cottage Constructions" }
]

created_clients = clients.map { |client| Client.create!(client) }

# Create custom fields for each client
puts "Creating custom fields..."
custom_fields_data = {
  "Skyscraper Specialists" => [
    { name: "number of floors", field_type: "number" },
    { name: "elevator count", field_type: "number" },
    { name: "building material", field_type: "enum", options: "steel,concrete,glass" }
  ],
  "Green Home Builders" => [
    { name: "solar panel count", field_type: "number" },
    { name: "energy efficiency rating", field_type: "enum", options: "a,b,c,d,e" },
    { name: "garden size (sq ft)", field_type: "number" }
  ],
  "Historic Renovations Inc." => [
    { name: "year built", field_type: "number" },
    { name: "architectural style", field_type: "freeform" },
    { name: "original features preserved", field_type: "freeform" }
  ],
  "Modern Office Designs" => [
    { name: "open plan percentage", field_type: "number" },
    { name: "conference room count", field_type: "number" },
    { name: "tech integration level", field_type: "enum", options: "basic,advanced,cutting-edge" }
  ],
  "Cozy Cottage Constructions" => [
    { name: "fireplace count", field_type: "number" },
    { name: "porch size (sq ft)", field_type: "number" },
    { name: "roof material", field_type: "enum", options: "thatch,slate,tile" }
  ]
}

created_clients.each do |client|
  custom_fields_data[client.name].each do |field_data|
    client.custom_fields.create!(field_data)
  end
end

# Create buildings with custom field values
puts "Creating buildings with custom field values..."
building_data = [
  { client: "Skyscraper Specialists", address: "123 Tall St, Skyline City", custom_fields: { "number of floors": "50", "elevator count": "8", "building material": "steel" } },
  { client: "Skyscraper Specialists", address: "456 High Ave, Cloudscraper Town", custom_fields: { "number of floors": "40", "elevator count": "6", "building material": "glass" } },
  { client: "Green Home Builders", address: "789 Eco Lane, Greenville", custom_fields: { "solar panel count": "20", "energy efficiency rating": "a", "garden size (sq ft)": "500" } },
  { client: "Green Home Builders", address: "101 Sustainable St, Eco Springs", custom_fields: { "solar panel count": "15", "energy efficiency rating": "b", "garden size (sq ft)": "350" } },
  { client: "Historic Renovations Inc.", address: "222 Heritage Rd, Oldtown", custom_fields: { "year built": "1890", "architectural style": "victorian", "original features preserved": "stained glass windows, ornate staircase" } },
  { client: "Historic Renovations Inc.", address: "333 Antique Blvd, Classic City", custom_fields: { "year built": "1905", "architectural style": "edwardian", "original features preserved": "fireplace, wood paneling" } },
  { client: "Modern Office Designs", address: "444 Innovation Way, Tech Park", custom_fields: { "open plan percentage": "80", "conference room count": "5", "tech integration level": "cutting-edge" } },
  { client: "Modern Office Designs", address: "555 Future St, Silicon Valley", custom_fields: { "open plan percentage": "70", "conference room count": "8", "tech integration level": "advanced" } },
  { client: "Cozy Cottage Constructions", address: "666 Quaint Lane, Countryside", custom_fields: { "fireplace count": "2", "porch size (sq ft)": "200", "roof material": "thatch" } },
  { client: "Cozy Cottage Constructions", address: "777 Charming Rd, Rustic Town", custom_fields: { "fireplace count": "1", "porch size (sq ft)": "150", "roof material": "slate" } }
]

building_data.each do |building|
  client = Client.find_by(name: building[:client])
  new_building = client.buildings.create!(address: building[:address])

  building[:custom_fields].each do |field_name, value|
    custom_field = client.custom_fields.find_by(name: field_name)
    new_building.custom_field_values.create!(custom_field: custom_field, value: value)
  end
end

puts "Seed data creation completed!"