class CommentsSerializer
  include FastJsonapi::ObjectSerializer
  set_type :comments
  attributes :content
end
