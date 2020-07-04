class ArticleSerializer
  include FastJsonapi::ObjectSerializer
  set_type :article
  attributes :title, :content, :slug
end
