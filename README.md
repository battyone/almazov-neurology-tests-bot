## Tests bot

### Description

This bot is developed for Department of Neurology and Psychiatry (Almazov National Medical Research Centre, St.Petersburg, Russia).

It's designed for clinical interns and doctors taking advanced training courses.

But you can use it as quiz bot.

Implemented in Ruby using Active Record and PostgreSQL.

Language: Russian.

### Launching

1. Download or clone repo. Use bundler.

```bash
$ bundle install
```

2. Setup database settings as you need.

```bash
$ cp data/database.yml.example config/database.yml
```

3. Setup XML or Plain text file with tests if you need.

```bash
$ cp data/questions.txt.example data/questions.txt
$ cp data/questions.xml.example data/questions.xml
```

You have to format them according to the samples.

4. Setup Telegram bot token (use [@botfather](https://telegram.me/botfather) to get it) and if you need URL where you store test texts.

```bash
$ cp .env.example .env
```

5. In `models/test.rb` leave only one uncommented line of three as you need.

```rb
#self.questions = Parser.questions_from_plain
self.questions = Parser.questions_from_remote_plain
# self.questions = Parser.questions_from_xml
```

6. Create and migrate your database.

```bash
$ bundle exec rake db:create db:migrate
```

7. Now you can start the bot.

```bash
$ bin/bot
```

### TODO

* Ask how many questions the user wants
* Make it possible to leave reviews

### License

MIT – see `LICENSE`

### Contacts

Email me at

```rb
'dcdl-snotynu?fl`hk-bnl'.each_char.map(&:succ).join
```
