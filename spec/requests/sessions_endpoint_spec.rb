RSpec.describe "app/v1/sessions endpoint" do
  describe "Happy Path" do
    before :each do
      @email = "email@domain.com"
      @password = "password"
      password_confirmation = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: @email, password: @password, password_confirmation: password_confirmation}
      post "/api/v1/users", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      @api_key = body[:data][:attributes][:api_key]
    end

    it "returns a 200 respons with nessisary return data" do
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: @email, password: @password}
      post "/api/v1/sessions", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(200)
      expect(body).to be_a(Hash)
      expect(body.keys).to eq([:data])
      expect(body[:data]).to be_a(Hash)
      expect(body[:data].keys).to eq([:id, :type, :attributes])
      expect(body[:data][:type]).to eq("users")
      expect(body[:data][:id].to_i).to be > 0
      expect(body[:data][:attributes]).to be_a(Hash)
      expect(body[:data][:attributes].keys).to eq([:email, :api_key])
      expect(body[:data][:attributes][:email]).to eq(@email)
      expect(body[:data][:attributes][:api_key]).to eq(@api_key)
    end
  end

  describe "Sad Path" do
    it "returns a 400 respons if no email provided" do
      password = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {password: password}
      post "/api/v1/sessions", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Invalid Login")

    end

    it "returns a 400 respons if email doesnt match any users" do
      email = "another@email.com"
      password = "password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email, password: password}
      post "/api/v1/sessions", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Invalid Login")
    end

    it "returns a 400 respons if password is incorrect" do
      email = "email@domain.com"
      password = "incorrect_password"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email, password: password}
      post "/api/v1/sessions", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Invalid Login")
    end

    it "returns a 400 respons if no password provided" do
      email = "email@domain.com"
      headers = {'CONTENT_TYPE' => 'application/json'}
      body = {email: email}
      post "/api/v1/sessions", headers: headers, params: body, as: :json
      body = JSON.parse(response.body, symbolize_names: true)

      expect(response.status).to eq(400)
      expect(body[:error]).to eq("Invalid Login")
    end
  end
end
