require 'rails_helper'

describe 'Usuário visita tela inicial' do
  it 'e vê galpões' do
    # Arrange
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)

    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    
    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'E-Commerce App'
    expect(page).to have_content 'Rio'
    expect(page).to have_content 'Maceió'
  end
  
  it 'e não existem galpões' do
    # Arrange
    fake_response = double("faraday_response", status: 200, body: "{}")

    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    
    # Act
    visit root_path

    # Assert
    expect(page).to have_content 'Nenhum galpão encontrado'
  end

  it 'e vê detalhes de um galpão' do
    # Arrange
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    
    json_data = File.read(Rails.root.join('spec/support/json/warehouse.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/2').and_return(fake_response)
    
    # Act
    visit root_path
    click_on 'Maceió'

    # Assert
    expect(page).to have_content 'Galpão MCZ - Maceió'
    expect(page).to have_content 'MCZ'
    expect(page).to have_content '50000 m²'
    expect(page).to have_content 'Av. Atlântica, 50 - CEP: 80000-000'
    expect(page).to have_content 'Galpão de Maceió.'
  end

  it 'e não é posível carregar galpão' do
    # Arrange
    json_data = File.read(Rails.root.join('spec/support/json/warehouses.json'))
    fake_response = double("faraday_response", status: 200, body: json_data)
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses').and_return(fake_response)
    
    error_response = double("faraday_response", status: 500, body: '{}')
    allow(Faraday).to receive(:get).with('http://localhost:4000/api/v1/warehouses/2').and_return(error_response)
    
    # Act
    visit root_path
    click_on 'Maceió'

    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Não foi possível carregar o galpão'
  end
end