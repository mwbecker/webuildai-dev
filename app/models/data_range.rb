class DataRange < ApplicationRecord
  belongs_to :feature
  has_many :categorical_data_options
end
