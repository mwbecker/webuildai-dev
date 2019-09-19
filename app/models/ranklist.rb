# frozen_string_literal: true

class Ranklist < ApplicationRecord
  belongs_to :participant
  has_many :ranklist_elements
end
