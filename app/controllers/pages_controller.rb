class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    logger.debug "PagesController#home called"
    authorize :page, :home?
  end
end
