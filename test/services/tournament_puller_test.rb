# frozen_string_literal: true

require 'test_helper'
require 'webmock/minitest'

class TournamentPullerTest < ActiveSupport::TestCase
  def setup
    WebMock.disable_net_connect!
    @request = stub_request(
      :get,
      "https://smash.gg/tournaments/?"\
      "filter=%7B%22upcoming%22:false,%22videogameIds%22:%2217%22,"\
      "%22past%22:true%7D&page=1&per_page=5"
    ).to_return(body: File.open("test/helpers/smash_tekken_list.html"))
  end

  test "pulls webpage from past tekken 7 tournament list" do
    TournamentPuller.new.web_page
    assert_requested(@request)
  end

  test "find the total number of tournaments available" do
    # update with new sample page
    num_tournaments = 2083
    assert_equal(num_tournaments, TournamentPuller.new.total_tournaments)
  end

  test "calculates total number of pages" do
    # update with new sample page
    total_pages = 417
    assert_equal(TournamentPuller.new.num_pages, total_pages)
  end
end

