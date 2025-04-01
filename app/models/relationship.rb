class Relationship < ApplicationRecord

  # userテーブルからデータを参照する（relationshipを経由して、参照） 
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

end
