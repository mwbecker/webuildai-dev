# frozen_string_literal: true

json.extract! participant, :id, :created_at, :updated_at
json.url participant_url(participant, format: :json)
