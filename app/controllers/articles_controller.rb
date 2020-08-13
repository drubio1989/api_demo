class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: [:index, :show]

  def index
    @articles = Article.all.order(created_at: :desc).page(params[:page]).per(params[:per_page] || 10)
    render_serialized_data(@articles)
  end

  def show
    @article = Article.find(params[:id])
    render_serialized_data(@article)
  end

  def create
    article = Article.new(article_params)
    if article.valid?
      # Does some stuff here.
    else
      #TODO: Implement this with json api documentatoin
      render json: article.errors, status: :unprocessable_entity
    end
  end

  private

  def article_params
    ActionController::Parameters.new
  end

  def render_serialized_data(object)
    render json: ArticleSerializer.new(object).serializable_hash
  end

  def render_serialized_error(errors)
    render json: ErrorSerializer.new(errors).serializable_hash
  end
end
