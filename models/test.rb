require 'active_record'
require './lib/parser'

class Test < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :questions

  validates :is_finished, inclusion: {in: [true, false]}, allow_nil: false

  after_initialize :restart, if: :new_record?

  def ask_question
    if current_question_index >= questions.count
      update_attribute(:is_finished, true)
      return finished_message
    end
    self.current_question = questions[current_question_index].to_s
    self.current_question_index += 1
    save

    current_question
  end

  def check_answer(id)
    question = questions[current_question_index - 1]

    return right_answer_message(question) unless (1..4).include?(id)
    return right_answer_message(question) unless current_question.split(/[1-4]\)\. /)[id].chomp == question.right_answer

    self.score += 1
    save
    'Верно'
  end

  private

  def restart
    self.score = 0
    self.current_question_index = 0
    self.questions = Parser.questions_from_plain
    # self.questions = Parser.questions_from_remote_plain
    # self.questions = Parser.questions_from_xml
    self.is_finished = false
  end

  def finished_message
    "Вопросы закончились. Вы ответили верно на #{I18n.t(:question, count: score)} из #{questions.count}\n" \
      "Чтобы начать заново, нажмите /start"
  end

  def right_answer_message(question)
    "Правильный ответ: #{question.right_answer}"
  end
end
