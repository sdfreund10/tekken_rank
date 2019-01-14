# frozen_string_literal: true

class Tournament < ApplicationRecord
  validates_presence_of %i(slug name start_at end_at api_id)
end

