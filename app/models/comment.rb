class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  validates :body, presence: true
  validate :cannot_attempt_to_influence_election

  private
    def cannot_attempt_to_influence_election
      trigger_words = [ "Trump", "Harris" ]
      found_words = trigger_words.select { |word| body&.include?(word) }

      unless found_words.empty?
        errors.add(:body, "Your comment attempts to influence the election by using words: #{found_words.join(', ')}")
      end
    end
end
