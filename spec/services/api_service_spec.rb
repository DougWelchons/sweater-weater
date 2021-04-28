require 'rails_helper'

RSpec.describe ApiService do
  describe "class methoids" do
    it ".base_url" do
      expect { ApiService.base_url }.to raise_error("self.base_url, must be defined in child class!")
    end
  end
end
