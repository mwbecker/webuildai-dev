# frozen_string_literal: true

class ParticipantFeatureWeight < ApplicationRecord
  belongs_to :participant
  belongs_to :feature

  scope :how_you, -> { where(method: 'how_you') }
  scope :how_ai, -> { where(method: 'how_ai') }

end
