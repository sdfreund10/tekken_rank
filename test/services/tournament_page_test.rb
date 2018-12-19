# frozen_string_literal: true

require 'test_helper'
require 'webmock/minitest'

class TournamentsPageTest < ActiveSupport::TestCase
  def setup
    @web_page = File.open("test/helpers/smash_tekken_list.html")
    @page = TournamentsPage.new(Nokogiri.parse(@web_page))
  end

  test "#tournament_card_headers selects headers from page" do
    # change with new sample page
    assert_equal(@page.tournament_card_headers.length, 5) 
  end

  test "it raises error if provided non-parsed page" do
    assert_raise StandardError do
      TournamentsPage.new(@web_page)
    end
  end

  test "#tournament_data parses the names from the web page" do
    names = @page.tournament_data.map { |hash| hash[:name] }.sort
    
    # change with new sample file
    assert_equal(
      names,
      ["CouchWarriors x Twitch Path to EVO Tekken 7 Online Tournament #3",
       "GoTE FGC Weekly #187",
       "KPS Cup 2 Week 6",
       "Shocker Showdown #3",
       "Token Throwdown @ Token Game Tavern!"]
    )
  end
  
  test "#tournament_data parses the links from the web page" do
    links = @page.tournament_data.map { |hash| hash[:href] }.sort

    assert_equal(
      links,
      ["/tournament/couchwarriors-x-twitch-path-to-evo-tekken-7-online-tournament-2",
       "/tournament/gote-fgc-weekly-187",
       "/tournament/kps-cup-2-week-6",
       "/tournament/shocker-showdown-3",
       "/tournament/token-throwdown-token-game-tavern"]
    )
  end

  test "#tournament_data parses the dates from the web page" do
    dates = @page.tournament_data.map { |hash| hash[:date] }.sort

    assert_equal(
      dates,
      ["December 16th, 2018",
       "December 16th, 2018",
       "December 16th, 2018",
       "December 18th, 2018",
       "December 18th, 2018"]
    )
  end
end

