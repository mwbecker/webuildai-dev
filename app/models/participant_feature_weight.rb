class ParticipantFeatureWeight < ApplicationRecord
  belongs_to :participant
  belongs_to :feature
end
