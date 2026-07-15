class Admin::CommentsController < Admin::BaseController
  def destroy
    comment = Comment.find(params[:id])
    post = comment.post
    comment.destroy
    redirect_to admin_post_path(post), notice: "コメントを削除しました"
  end
end
