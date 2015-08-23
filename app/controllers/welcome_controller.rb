class WelcomeController < ApplicationController
  def index
    @count = Rails.cache.read(:count).to_i
    Rails.cache.write(:count, @count+1)
  end
end
