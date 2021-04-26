require 'rails_helper'

RSpec.describe "app/v1/users endpoint" do
  describe "Happy Path" do
    it "returns a 201 respons with nessisary return data" do
      email = "email@domain.com"
      password = "password"
      password_confirmation = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email, password: password, password_confirmation: password_confirmation}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(201)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:data])
      expect(body[:data]).to be_a(Hash)
      expect(body[:data].keys).to eq([:type, :id, :attributes])
      expect(body[:data][:type]).to eq("users")
      expect(body[:data][:id]).to be_a(Integer)
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes].keys).to eq([:email, :api_key])
      expect(body[:data][:attributes][:email]).to eq(email)
      expect(body[:data][:attributes][:api_key]).to be_a(String)
    end
  end
end
