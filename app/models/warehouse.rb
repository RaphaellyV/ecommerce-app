class Warehouse
  attr_accessor :name, :code, :city, :area, :address, :postal_code, :description, :state, :id

  def initialize(name:, code:, city:, area:, address:, postal_code:, description:, state:, id:)
    @name = name
    @code = code
    @city = city
    @area = area
    @address = address
    @postal_code = postal_code
    @description = description
    @state = state
    @id = id
  end

  def self.all
    warehouses = []

    response = Faraday.get('http://localhost:4000/api/v1/warehouses')
    if response.status == 200
      data = JSON.parse(response.body)
      data.each do |d|
        warehouses << Warehouse.new(name: d["name"], code: d["code"], city: d["city"], area: d["area"], address: d["address"],
                                    postal_code: d["postal_code"], description: d["description"], state: d["state"], id: d["id"])
      end
    end
    
    warehouses
  end
end