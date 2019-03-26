require 'active_record'

class Question < ActiveRecord::Base
  has_and_belongs_to_many :tests

  validates :text, presence: true, uniqueness: true
  validates :answer1, :answer2, :answer3, :answer4, presence: true
  validates :right_answer, presence: true

  def to_s
    [answer1, answer2, answer3, answer4].
      shuffle.
      map.
      with_index(1) { |answer, index| "#{index}). #{answer}" }.
      unshift(text).
      join("\n")
  end
end
