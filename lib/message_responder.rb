require './models/user'
require './models/test'
require './lib/message_sender'

class MessageResponder
  attr_reader :message
  attr_reader :bot
  attr_reader :user
  attr_reader :test

  def initialize(options)
    @bot = options[:bot]
    @message = options[:message]
    @user = User.find_or_create_by(uid: message.from.id)
    @test = Test.find_or_create_by(user_id: user.id)
  end

  def respond
    on /\A\/start/ do
      answer_with_start_message

      user.test.destroy
      @test = user.create_test

      answer_with_message "Всего будет задано #{I18n.t(:question, count: test.questions.count)}"
      answer_with_message test.ask_question
    end

    on /\A\/about/ do
      answer_with_about_message
    end

    on /\A(?!(\/start|\/about))/ do
      answer_with_message test.check_answer(message.text.to_i) unless test.is_finished
      answer_with_message test.ask_question
    end
  end

  private

  def on regex, &block
    regex =~ message.text

    if $~
      case block.arity
      when 0
        yield
      when 1
        yield $1
      when 2
        yield $1, $2
      end
    end
  end

  def answer_with_start_message
    answer_with_message I18n.t('start_message')
  end

  def answer_with_about_message
    answer_with_message I18n.t('about_message')
  end

  def answer_with_message(text)
    MessageSender.new(bot: bot, chat: message.chat, text: text).send
  end
end
