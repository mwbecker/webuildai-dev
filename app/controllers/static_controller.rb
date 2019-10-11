# frozen_string_literal: true

class StaticController < ApplicationController
  def index; end

  def base
    redirect_to '/react/'
  end

  def marco
    render json: { polo: 'some text here' }.to_json
  end
end
