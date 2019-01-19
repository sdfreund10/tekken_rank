# frozen_string_literal: true

require 'test_helper'
require 'mocha/minitest'
require 'webmock/minitest'
load Rails.root.join('test', 'helpers', 'tournament_reponse.rb')

class API::TournamentDataTest < ActiveSupport::TestCase
  def setup
    WebMock.disable_net_connect!
    # makes lots of external api requests
    TournamentPuller.any_instance.stubs(:all_tournament_codes).returns(
      [
        { name: 'Tournament A',
          href: 'tournament/tournament-a',
          date: 'December 18th 2018' }
      ]
    )
  end

  def stub_tournaments
    uri_template = Addressable::Template.new(
      'https://api.smash.gg/tournament/{slug}?'\
        'expand[]=event&expand[]=groups&expand[]=phase'
    )
    stub_request(:any, uri_template).to_return(
      body: TOURNAMENT_RESPONSE.to_json
    )
  end

  test '#data fetches tournament data from api' do
    stub = stub_tournaments
    scraper = API::TournamentData.new('Tournament A', 'tournament/tournament-a')
    scraper.data

    assert_requested(stub)
  end

  test '#tekken_events gets event data with tekken 7 id' do
    stub_tournaments
    scraper = API::TournamentData.new('Tournament A', 'tournament/tournament-a')
    events = scraper.tekken_events
    events.each do |event|
      assert_equal(event['videogameId'], 17)
      assert_match(/\Atournament\/.*\/event\/.*\z/, event['slug'])
    end
  end

  test '#tekken_phases selects phases belonging to tekken events' do
    stub = stub_tournaments
    scraper = API::TournamentData.new('Tournament A', 'tournament/tournament-a')
    phases = scraper.tekken_phases

    phases.each do |phase|
      # may only be true for test data
      assert_equal phase['name'], 'Bracket'
      assert_includes(
        scraper.tekken_events.map { |ev| ev['id'] },
        phase['eventId']
      )
    end
  end

  test '#tekken_groups selects groups belonging to tekken phases' do
    stub = stub_tournaments
    scraper = API::TournamentData.new('Tournament A', 'tournament/tournament-a')
    groups = scraper.tekken_groups

    groups.each do |group|
      # may only be true for test data
      assert_equal group['percentageComplete'], '1.0000'
      assert_includes(
        scraper.tekken_phases.map { |ev| ev['id'] },
        group['phaseId']
      )
    end
  end
end
