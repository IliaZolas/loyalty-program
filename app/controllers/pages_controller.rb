class PagesController < ApplicationController
    skip_before_action :authenticate_user!, only: :home

  def home
    if user_signed_in?
      @rewards = current_user.rewards.order(issued_at: :desc)
    else
      @rewards = []  
    end
  end

end
