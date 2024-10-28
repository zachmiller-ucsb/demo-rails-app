module Visible
  extend ActiveSupport::Concern

  included do
    validate :cannot_attempt_to_influence_election
  end

  private
    def cannot_attempt_to_influence_election
      trigger_words = [ "Trump", "Harris" ]
      found_words_title = trigger_words.select { |word| title_contains?(word) }
      found_words_body = trigger_words.select { |word| body_contains?(word) }

      unless found_words_title.empty?
        errors.add(:title, "This line attempts to influence the election by using words: #{found_words_title.join(', ')}")
      end

      unless found_words_body.empty?
        errors.add(:body, "This line attempts to influence the election by using words: #{found_words_body.join(', ')}")
      end
    end

    def title_contains?(word)
      respond_to?(:title) && title&.include?(word)
    end

    def body_contains?(word)
      respond_to?(:body) && body&.include?(word)
    end
end
