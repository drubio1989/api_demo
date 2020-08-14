class CommentsController < ApplicationController
  skip_before_action :authorize!, only: [:index]

  def index
    @comments = Comment.all
    render_serialized_data(@comments, :ok)
  end

  def create
    article = Article.find(params[:article_id])
    @comment = article.comments.build(comments_params.merge(user: current_user))

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  private 

  def comments_params
    params.require(:comment).permit(:content, :article_id)
  end

  def render_serialized_data(object)
    render json: CommentSerializer.new(object).serializable_hash, status: status
  end
end
