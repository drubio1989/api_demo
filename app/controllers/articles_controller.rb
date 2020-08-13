class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]

  def index
    @articles = Article.all.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 10)
    render_serialized_data(@articles, :ok)
  end

  def show
    @article = Article.find(params[:id])
    render_serialized_data(@article, :ok)
  end

  def create
    @article = current_user.articles.build(article_params)
    @article.save!
    render_serialized_data(@article, :created)
  rescue
      #TODO: Implement this with json api documentatoin
    render json: @article.errors, status: :unprocessable_entity
  end

  def update
    @article = current_user.articles.find(params[:id])
    @article.update_attributes!(article_params)
    render_serialized_data(@article, :no_content)
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue
      #TODO: Implement this with json api documentatoin
    render json: @article.errors, status: :unprocessable_entity
  end

  def destroy
    @article = current_user.articles.find(params[:id])
    @article.destroy
    head :no_content
  rescue ActiveRecord::RecordNotFound
    authorization_error
  end

  private

  def article_params
    params.require(:data).require(:attributes).permit(:title, :content, :slug)
  end

  def render_serialized_data(object, status)
    render json: ArticleSerializer.new(object).serializable_hash, status: status
  end
end
