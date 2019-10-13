# frozen_string_literal: true

class Feature < ApplicationRecord
  has_many :scenarios
  has_one :data_range
  has_many :categorical_data_options, through: :data_range
  has_many :participant_feature_weights

  scope :active, -> { where(active: true) }
  scope :request, -> { where(category: 'request') }
  scope :driver, -> { where(category: 'driver') }
  scope :added_by, ->(user_id) { where('added_by = ? OR added_by IS NULL', user_id.to_s) }
  scope :company, -> { where('(description != ? AND description != ?) or company = true', 'Your Own Feature(s) - Continuous', 'Your Own Feature(s) - Categorical') }
  scope :personal, -> { where(company: false) }

  def self.for_user(user_id, category)
    feats = []
    category = (category == "request") ? "how_you" : "how_ai"
    joins(:participant_feature_weights).where('participant_feature_weights.weight > 0 AND participant_feature_weights.participant_id = ? AND participant_feature_weights.method = ?', user_id, category).each do |f|
      feats << f
    end
    feats
  end

  # returns a list that matches feature id to its weight for a given user
  def self.features_and_weights(user_id, category)
    feature_weights = Array.new
    category = (category == "request") ? "how_you" : "how_ai"
    joins(:participant_feature_weights).where('participant_feature_weights.weight > 0 AND participant_feature_weights.participant_id = ? AND participant_feature_weights.method = ?', user_id, category).each do |f|
      weight = []
      weight << f.name
      weight << f.participant_feature_weights.where(participant_id: user_id, method: category).first.weight
      feature_weights << weight
    end
    feature_weights

  end

end
