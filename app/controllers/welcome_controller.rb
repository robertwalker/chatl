class WelcomeController < ApplicationController
  def index
    # TODO: Remove this once we have a decent welcome page.
    redirect_to next_meeting_path
  end
end
