require './lib/app_configurator'

class MessageSender
  REPLY_MARKUP =
    Telegram::Bot::Types::ReplyKeyboardMarkup.new(
      keyboard: [
        %w[1 2 3],
        %w[4 5 6],
        %w[7 8 9],
        %w[/about 0 /start]
      ]
    ).freeze

  attr_reader :bot
  attr_reader :text
  attr_reader :chat
  attr_reader :answers
  attr_reader :logger

  def initialize(options)
    @bot = options[:bot]
    @text = options[:text]
    @chat = options[:chat]
    @answers = options[:answers]
    @logger = AppConfigurator.new.get_logger
  end

  def send
    bot.api.send_message(chat_id: chat.id, text: text, reply_markup: REPLY_MARKUP,
                         parse_mode: 'markdown', disable_web_page_preview: true)
    logger.debug "sending '#{text}' to #{chat.username}"
  end
end
