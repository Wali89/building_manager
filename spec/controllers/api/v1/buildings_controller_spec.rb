require 'rails_helper'

RSpec.describe Api::V1::BuildingsController, type: :controller do
  let(:client) { Client.create(name: 'Test Client') }
  let(:building) { Building.create(address: '123 Test St', client: client) }

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns buildings in the response' do
      building # create the building
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response['buildings']).to be_an(Array)
      expect(json_response['buildings'].length).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { client_id: client.id, id: building.id }
      expect(response).to be_successful
    end

    it 'returns the correct building' do
      get :show, params: { client_id: client.id, id: building.id }
      json_response = JSON.parse(response.body)
      expect(json_response['building']['id']).to eq(building.id.to_s)
      expect(json_response['building']['address']).to eq(building.address)
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) { { address: '456 New St', custom_fields: {} } }

    it 'creates a new building' do
      expect {
        post :create, params: { client_id: client.id, building: valid_attributes }
      }.to change(Building, :count).by(1)
    end

    it 'returns a successful response' do
      post :create, params: { client_id: client.id, building: valid_attributes }
      expect(response).to be_successful
    end
  end

  describe 'PUT #update' do
    let(:new_attributes) { { address: '789 Updated St' } }

    it 'updates the building' do
      put :update, params: { client_id: client.id, id: building.id, building: new_attributes }
      building.reload
      expect(building.address).to eq('789 Updated St')
    end

    it 'returns a successful response' do
      put :update, params: { client_id: client.id, id: building.id, building: new_attributes }
      expect(response).to be_successful
    end
  end

  describe 'GET #client_buildings' do
    it 'returns a successful response' do
      get :client_buildings, params: { client_id: client.id }
      expect(response).to be_successful
    end

    it 'returns buildings for the specified client' do
      building # create the building
      get :client_buildings, params: { client_id: client.id }
      json_response = JSON.parse(response.body)
      expect(json_response['buildings']).to be_an(Array)
      expect(json_response['buildings'].length).to eq(1)
      expect(json_response['buildings'][0]['id']).to eq(building.id.to_s)
    end
  end
end