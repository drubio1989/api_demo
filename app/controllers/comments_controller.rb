class CommentsController < ApplicationController
  skip_before_action :authorize!, only: [:index]
  before_action :find_article

  def index
    comments = @article.comments.page(params[:page]).per(params[:per_page])
    render_serialized_data(comments, :ok)
  end

  def create
    article = Article.find(params[:article_id])
    @comment = article.comments.build(comments_params.merge(user: current_user))
    @comment.save!
    render_serialized_data(@comment, :created)
  rescue
    render json: @comment.errors, status: :unprocessable_entity
  end

  private

  def find_article
    @article = Article.find_by(params[:article_id])
  end

  def comments_params
    params.require(:data).require(:attributes).permit(:content)
  end

  def render_serialized_data(object, status)
    render json: CommentSerializer.new(object).serializable_hash, status: status
  end
end
