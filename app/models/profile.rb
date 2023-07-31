class Profile < ApplicationRecord
  belongs_to :user

  #男女の番号を保存させる
  enum sex: { man: 0, woman: 1}
end
