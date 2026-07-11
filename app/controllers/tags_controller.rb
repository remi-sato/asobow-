class TagsController < ApplicationController
  def index
    @word = params[:word]

    @tags = 
      if @word.present?
        Tag.where("name LIKE?", "%#{Tag.sanitize_sql_like(@word)}%") .order(:name)
      else
        Tag.order(:name)
      end
  end

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.order(created_at: :desc)
  end
end
