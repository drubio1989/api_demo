class ArticleSerializer
  include FastJsonapi::ObjectSerializer
  set_type :articles
  attributes :title, :content, :slug
  has_many :comments
  belongs_to :user
end
