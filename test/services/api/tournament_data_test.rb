# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'
require 'webmock/minitest'

class API::TournamentDataTest < ActiveSupport::TestCase
  def setup
    WebMock.disable_net_connect!
    # makes lots of external api requests
    TournamentPuller.any_instance.stubs(:all_tournament_codes).returns(
      [
        { name: "Tournament A",
          href: "tournament/tournament-a",
          date: "December 18th 2018" }
      ]
    )
  end

  def stub_tournaments
    uri_template = Addressable::Template.new(
      "https://api.smash.gg/tournament/{slug}"
    )
    load Rails.root.join("test", "helpers", "tournament_reponse.rb")
    stub_request(:any, uri_template).to_return(
      body: TOURNAMENT_RESPONSE.to_json
    )
  end

  test "#data fetches tournament data from api" do
    stub = stub_tournaments
    scraper = API::TournamentData.new("Tournament A", "tournament/tournament-a")
    scraper.data

    assert_requested(stub)
  end
end

