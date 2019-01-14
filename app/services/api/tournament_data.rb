# frozen_string_literal: true

require "open-uri"

class API::TournamentData
  BASE_URL = "https://api.smash.gg/".freeze

  def initialize(tournament_name, href)
    @href = href
  end

  def data
    @data ||= api_data = JSON.parse(open(BASE_URL + @href).read)
  end

  def tournament_data
    data.dig("entities", "tournament")
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

