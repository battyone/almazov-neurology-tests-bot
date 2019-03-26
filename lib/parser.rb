require 'rexml/document'
require 'net/http'
require 'uri'
require 'dotenv/load'
require './models/question.rb'

class Parser
  def self.questions_from_xml
    doc = REXML::Document.new(File.new("#{__dir__}/../data/questions.xml"))
    questions = []

    doc.elements.each('//question') do |question|
      answers = []
      right_answer = nil

      text = question.elements['text'].text

      question.elements.each('*/answer') do |answer|
        right_answer = answer.text if answer.attributes['right']
        answers << answer.text
      end

      answer1, answer2, answer3, answer4 = answers
      questions << Question.find_or_create_by(text: text) do |q|
                     q.answer1 = answer1
                     q.answer2 = answer2
                     q.answer3 = answer3
                     q.answer4 = answer4
                     q.right_answer = right_answer
                   end
    end
    questions
  end

  def self.questions_from_plain
    doc = File.read("#{__dir__}/../data/questions.txt")
    questions = []

    doc.split("\n").each_slice(5).to_a.each do |qa|
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
    questions
  end

  def self.questions_from_remote_plain
    uri = URI.parse(ENV['QUESTIONS_URL'])
    doc = Net::HTTP.get_response(uri).body
    questions = []

    doc.force_encoding("utf-8").split("\r\n").each_slice(5).to_a.each do |qa|
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
    questions
  end
end
