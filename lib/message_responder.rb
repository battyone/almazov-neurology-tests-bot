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
      answer_with_message I18n.t(:how_many_questions), true
      user.test.destroy
      @test = user.create_test
    end

    on /\A\/about/ do
      answer_with_about_message
    end

    on /\A(?!(\/start|\/about))/ do
      if test.just_started
        questions_qty_wants = message.text.to_i

        if questions_qty_wants <= 0
          answer_with_message I18n.t(:how_many_questions), true
        else
          user.test.destroy
          @test = user.create_test(questions_qty_wants: questions_qty_wants)

          answer_with_message I18n.t(
            :ask_questions, questions: I18n.t(:question, count: test.questions.count),
            from_available: I18n.t(:from_available, count: test.total_qty)
          )

          answer_with_message test.ask_question
        end
      else
        answer_with_message test.check_answer(message.text.to_i) unless test.is_finished
        answer_with_message test.ask_question
      end
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
    answer_with_message I18n.t(:start), true
  end

  def answer_with_about_message
    answer_with_message I18n.t(:about)
  end

  def answer_with_message(text, no_keyboard = false)
    MessageSender.new(bot: bot, chat: message.chat, text: text, no_keyboard: no_keyboard).send
  end
end
