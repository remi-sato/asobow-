class TagsController < ApplicationController
  before_action :require_login

  def index
    @word = params[:word]

    tags = Tag.joins(:posts).distinct

    @tags =
      if @word.present?
        tags.where(
          "tags.name LIKE ?",
          "%#{Tag.sanitize_sql_like(@word)}%"
        )
      else
        tags
      end

    @tags = @tags.order(:name)
                 .page(params[:page])
                 .per(12)
  end

  def show
    @tag = Tag.find(params[:id])

    @posts = @tag.posts
                 .includes(:user)
                 .order(created_at: :desc)
                 .page(params[:page])
                 .per(20)
  end
end