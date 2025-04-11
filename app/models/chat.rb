class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # バリデーション（メッセージが空でなく、140文字以内であることを確認）
  validates :message, presence: true, length: { maximum: 140 }
end
