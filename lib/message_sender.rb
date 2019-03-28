require './lib/app_configurator'

class MessageSender
  REPLY_MARKUP =
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      one_time_keyboard: true,
      keyboard: [
        %w[1 2 /start],
        %w[3 4 /about]
      ]
    ).freeze

  attr_reader :bot
  attr_reader :text
  attr_reader :chat
  attr_reader :no_keyboard
  attr_reader :logger

  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
    @no_keyboard = options[:no_keyboard]
    @logger = AppConfigurator.new.get_logger
  end

  def send
    if no_keyboard
      bot.api.send_message(chat_id: chat.id, text: text)
    else
      bot.api.send_message(chat_id: chat.id, text: text, reply_markup: REPLY_MARKUP,
                           parse_mode: 'markdown', disable_web_page_preview: true)
    end

    logger.debug "sending '#{text}' to #{chat.username}"
  end
end
