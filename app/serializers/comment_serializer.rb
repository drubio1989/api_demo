class CommentSerializer
  include FastJsonapi::ObjectSerializer
  set_type :comments
  attributes :content
  belongs_to :article
  belongs_to :user
end
