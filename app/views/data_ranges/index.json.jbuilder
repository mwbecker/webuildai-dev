# frozen_string_literal: true

json.array! @data_ranges, partial: 'data_ranges/data_range', as: :data_range
