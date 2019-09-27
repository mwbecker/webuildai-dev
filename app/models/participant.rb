# frozen_string_literal: true

class Participant < ApplicationRecord
  require 'shellwords'
  has_secure_password

  has_many :pairwise_comparisons
  has_many :scenarios
  has_many :participant_feature_weights
  has_many :abouts

  def self.authenticate(id, password)
    find_by_id(id).try(:authenticate, password)
  end

  def generate_model
    json_path = generate_json # generates the json and returns path to it.

    # to do: change open to generating the model
    # use shellescape to sanitize (just in case, don't think it's necessary)
    model_path = Rails.root.join('app/models/ex_file.py').to_s.shellescape
    `python3 #{model_path} #{json_path.shellescape}`
  end

  private

  def generate_json
    o = OutputData.new(id)
    o.output
  end
end
