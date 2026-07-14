class TagsController < ApplicationController
  def index
    @word = params[:word]

    @tags =
      if @word.present?
        Tag.where("name LIKE ?", "%#{Tag.sanitize_sql_like(@word)}%")
           .order(:name)
           .page(params[:page])
           .per(12)
      else
        Tag.order(:name)
           .page(params[:page])
           .per(12)
      end
  end

  def show
    @tag = Tag.find(params[:id])
    @posts = @tag.posts.order(created_at: :desc).page(params[:page]).per(20)
  end
end
