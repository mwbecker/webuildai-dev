class IndividualScenario < ApplicationRecord
  belongs_to :participant
  has_many :ranklist_elements

end