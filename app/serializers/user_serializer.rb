class UserSerializer
  include FastJsonapi::ObjectSerializer
  set_type :users
  attributes :id, :login, :avatar_url, :url, :name
  has_many :articles
  has_many :comments, through: :articles
end
