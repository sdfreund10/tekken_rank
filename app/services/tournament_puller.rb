# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class TournamentPuller
  PER_PAGE = 5
  def pull_all_tournament_codes
    (1..num_pages).map do |page_num|
      sleep(0.5) # rate limit
      page = web_page(page_num)
      page.search("div.TournamentCardHeading").map do |head|
        link = head.at_css('div.TournamentCardHeading__title a')
        name = link.inner_text 
        href = link["href"]
        date = head.at_css('div.TournamentCardHeading__information span').
                    inner_text
        
        { name: name, href: href, date: date }
      end
    end
  end

  def total_tournaments
    @total_tournaments ||= web_page.
                            search(".text-muted").
                            inner_text.
                            scan(/\d+/).
                            last.
                            to_i
  end

  def num_pages
    (total_tournaments / PER_PAGE) + 1
  end

  def web_page(page_num = 1)
    url = URI.encode(
      "https://smash.gg/tournaments/?"\
      "per_page=#{PER_PAGE}&page=#{page_num}"\
      "&filter={\"upcoming\":false,\"videogameIds\":\"17\",\"past\":true}"
    )
    Nokogiri::HTML(
      open(url)
    )
  end
end

