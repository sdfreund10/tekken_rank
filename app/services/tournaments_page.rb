# frozen_string_literal: true

class TournamentsPage
  def initialize(web_page)
    unless web_page.is_a? Nokogiri::HTML::Document
      raise "Web Page must be parse with Nokogiri before extracting "\
            "tournament data"
    end

    @web_page = web_page
  end

  def tournament_data
    tournament_card_headers.map do |card|
      link = card.at_css('div.TournamentCardHeading__title a')
      name = link.inner_text 
      href = link["href"]
      date = card.at_css('div.TournamentCardHeading__information span').
                  inner_text
      
      { name: name, href: href, date: date }
    end
  end

  def tournament_card_headers
    @web_page.search("div.TournamentCardHeading")
  end
end

