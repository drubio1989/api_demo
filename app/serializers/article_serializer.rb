class ArticleSerializer
  include FastJsonapi::ObjectSerializer
  set_type :articles
  attributes :title, :content, :slug
end
