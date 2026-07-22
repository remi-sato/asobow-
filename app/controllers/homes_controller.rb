class HomesController < ApplicationController
  def top
    @posts = Post.where.not(latitude: nil, longitude: nil)
  end

  def about
  end
end
