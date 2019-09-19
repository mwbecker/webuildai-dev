# frozen_string_literal: true

json.array! @features, partial: 'features/feature', as: :feature
