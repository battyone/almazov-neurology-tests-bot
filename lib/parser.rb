require 'rexml/document'
require 'net/http'
require 'uri'
require 'dotenv/load'
require './models/question.rb'

class Parser
  def self.questions_from_plain(qty)
    doc = File.read("#{__dir__}/../data/questions.txt")
    questions = []

    items = doc.split("\n").each_slice(5).to_a
    qty = items.size if qty > items.size

    items.sample(qty).each do |qa|
      text = qa.shift[2..-1]
      right_answer = qa.grep(/#/).first[1..-1]
      answer1, answer2, answer3, answer4 = [right_answer] + qa.grep_v(/#/)

      questions << Question.find_or_create_by(text: text) do |q|
                     q.answer1 = answer1
                     q.answer2 = answer2
                     q.answer3 = answer3
                     q.answer4 = answer4
                     q.right_answer = right_answer
                   end
    end
    { selected: questions, total_qty: items.size }
  end

  def self.questions_from_remote_plain(qty)
    uri = URI.parse(ENV['QUESTIONS_URL'])
    doc = Net::HTTP.get_response(uri).body
    questions = []

    items = doc.force_encoding("utf-8").split("\r\n").each_slice(5).to_a
    qty = items.size if qty > items.size

    items.sample(qty).each do |qa|
      text = qa.shift[2..-1]
      right_answer = qa.grep(/#/).first[1..-1]
      answer1, answer2, answer3, answer4 = [right_answer] + qa.grep_v(/#/)

      questions << Question.find_or_create_by(text: text) do |q|
                     q.answer1 = answer1
                     q.answer2 = answer2
                     q.answer3 = answer3
                     q.answer4 = answer4
                     q.right_answer = right_answer
                   end
    end
    { selected: questions, total_qty: items.size }
  end
end
