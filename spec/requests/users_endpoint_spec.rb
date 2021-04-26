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
      expect(body[:data].keys).to eq([:id, :type, :attributes])
      expect(body[:data][:type]).to eq("users")
      expect(body[:data][:id].to_i).to be > 0
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes].keys).to eq([:email, :api_key])
      expect(body[:data][:attributes][:email]).to eq(email)
      expect(body[:data][:attributes][:api_key]).to be_a(String)
    end
  end

  describe "Sad Path" do
    it "returns a 400 respons if no email provided" do
      password = "password"
      password_confirmation = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {password: password, password_confirmation: password_confirmation}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Validation failed: Email can't be blank, Email is invalid")

    end

    it "returns a 400 respons if email is not in the right format" do
      email = "not an email"
      password = "password"
      password_confirmation = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {password: password, password_confirmation: password_confirmation}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Validation failed: Email can't be blank, Email is invalid")
    end

    it "returns a 400 respons if email already exists" do
      User.create!(email: "email@domain.com", password: "password", password_confirmation: "password" )
      email = "email@domain.com"
      password = "password"
      password_confirmation = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email, password: password, password_confirmation: password_confirmation}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Validation failed: Email has already been taken")
    end

    it "returns a 400 respons if passwords dont match" do
      email = "email@domain.com"
      password = "password"
      password_confirmation = "not_password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email, password: password, password_confirmation: password_confirmation}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Validation failed: Password confirmation doesn't match Password")
    end

    it "returns a 400 respons if no password provided" do
      email = "email@domain.com"
      password_confirmation = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email, password_confirmation: password_confirmation}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Validation failed: Password can't be blank")
    end

    it "returns a 400 respons if no password_confirmation provided" do
      email = "email@domain.com"
      password = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email, password: password}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Validation failed: Password confirmation can't be blank")
    end
  end
end
