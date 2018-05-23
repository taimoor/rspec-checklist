require 'rails_helper'

RSpec.describe "UserVotes", type: :request do
  describe "GET /user_votes" do
    it "works! (now write some real specs)" do
      get user_votes_path
      expect(response).to have_http_status(200)
    end
  end
end
