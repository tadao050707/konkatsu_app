class Profile < ApplicationRecord
  belongs_to :user

  #男女の番号を保存させる
  enum sex: { man: 0, woman: 1}
  #アイコンuploderを追加
  mount_uploader :icon, IconUploader

  def self.default_icons
    ['default_icon1.jpg', 'default_icon2.jpg', 'default_icon3.jpg', 'default_icon4.jpg', 'default_icon5.jpg', 'default_icon6.jpg', 'default_icon7.jpg']
  end
end
