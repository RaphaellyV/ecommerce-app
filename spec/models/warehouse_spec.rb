require 'rails_helper'

describe Warehouse do
  context '.all' do
    it 'deve retornar todos os galpões' do
      # Arrange
      json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
      fake_response = double("faraday_response", status: 200, body: json_data)

      allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)

      # Act
      result = Warehouse.all

      # Assert
      expect(result.length).to eq 2
      expect(result[0].name).to eq 'Maceió'
      expect(result[0].code).to eq 'MCZ'
      expect(result[0].city).to eq 'Maceió'
      expect(result[0].area).to eq 50000
      expect(result[0].address).to eq 'Av. Atlântica, 50'
      expect(result[0].postal_code).to eq '80000-000'
      expect(result[0].description).to eq 'Galpão de Maceió.'
      expect(result[0].state).to eq 'AL'
      expect(result[0].id).to eq 2
      expect(result[1].name).to eq 'Rio'
      expect(result[1].code).to eq 'SDU'
      expect(result[1].city).to eq 'Rio de Janeiro'
      expect(result[1].area).to eq 60000
      expect(result[1].address).to eq 'Av. do Porto, 1000'
      expect(result[1].postal_code).to eq '20000-000'
      expect(result[1].description).to eq 'Galpão do Rio.'
      expect(result[1].state).to eq 'RJ'
      expect(result[1].id).to eq 1
    end

    it 'deve retornar vazio se a API estiver indisponível' do
      # Arrange
      fake_response = double("faraday_resp", status: 500, body: "{ error: 'Erro ao obter dados' }")
      allow(Faraday).to receive(:get).with("http://localhost:4000/api/v1/warehouses").and_return(fake_response)

      # Act
      result = Warehouse.all

      # Assert
      expect(result).to eq []
    end
  end
end