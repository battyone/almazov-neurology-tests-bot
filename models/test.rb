require 'active_record'
require './lib/parser'

class Test < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :questions

  validates :is_finished, inclusion: {in: [true, false]}, allow_nil: false
  validates :just_started, inclusion: {in: [true, false]}, allow_nil: false
  validates :answered, inclusion: {in: [true, false]}, allow_nil: false
  validates :questions_qty_wants, numericality: { greater_than_or_equal_to: 1 }

  after_initialize :restart, if: :new_record?

  def ask_question
    if current_question_index >= questions.count
      update_attribute(:is_finished, true)
      return I18n.t(:finished, questions: I18n.t(:question, count: score), count: questions.count)
    end
    self.current_question = questions[current_question_index].to_s
    self.current_question_index += 1
    save
    update_attributes(just_started: false, answered: false)

    current_question
  end

  def check_answer(id)
    if answered
      update_attributes(is_finished: true, current_question_index: questions.count)
      return I18n.t(:more_than_one_answer)
    else
      update_attribute(:answered, true)
      question = questions[current_question_index - 1]
    end

    return I18n.t(:right_answer, right_answer: question.right_answer) unless (1..4).include?(id)
    return I18n.t(:right_answer, right_answer: question.right_answer) unless
      current_question.split(/[1-4]\)\. /)[id].chomp == question.right_answer

    self.score += 1
    save
    I18n.t(:right)
  end

  private

  def restart
    self.score = 0
    self.current_question_index = 0
    questions = Parser.questions_from_plain(questions_qty_wants)
    # questions = Parser.questions_from_remote_plain(questions_qty_wants)
    self.questions = questions[:selected]
    self.total_qty = questions[:total_qty]
    self.just_started = true
    self.is_finished = false
    self.answered = false
  end
end
