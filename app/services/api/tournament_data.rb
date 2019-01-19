# frozen_string_literal: true

require 'open-uri'

class API::TournamentData
  BASE_URL = 'https://api.smash.gg/'
  # find phase groups for the right game and get sets
  def initialize(_tournament_name, href)
    @href = href
  end

  def data
    @data ||= JSON.parse(
      open(
        BASE_URL + @href + '?expand[]=event&expand[]=groups&expand[]=phase'
      ).read
    )
  end

  def tournament_data
    data.dig('entities', 'tournament')
  end

  def tekken_events
    data.dig('entities', 'event').select { |event| event['videogameId'] == 17 }
  end

  def tekken_phases
    tekken_event_ids = tekken_events.map { |event| event['id'] }
    data.dig('entities', 'phase').select do |phase|
      tekken_event_ids.include? phase['eventId']
    end
  end

  def tekken_groups
    tekken_phase_ids = tekken_phases.map { |phase| phase['id'] }
    data.dig('entities', 'groups').select do |group|
      tekken_phase_ids.include? group['phaseId']
    end
  end

  def self.tournament_metadata
    tournaments.each do |base_data|
      name, href, date = base_data.values_at(:name, :href, :date)
      new(name, href)
    end
  end

  def self.tournaments
    TournamentPuller.new.all_tournament_codes
  end
end
