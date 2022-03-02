require_relative 'questions_database.rb'

# id INTEGER PRIMARY KEY,
#   body TEXT NOT NULL, 
#   question_id INTEGER NOT NULL, 
#   parent_reply_id INTEGER, 
#   user_id INTEGER NOT NULL,

class Replies

  attr_accessor :id, :body, :author_id, :title

   def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM replies")
    data.map { |datum| Replies.new(datum) }
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    return nil unless reply.length > 0 
    reply.map { |ele| Replies.new(ele) }

  end

  def self.find_by_user_id(user_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM
        replies
      WHERE
        user_id = ?
    SQL
    return nil unless reply.length > 0
    reply.map { |ele| Replies.new(ele) }
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    return nil unless reply.length > 0
    reply.map { |ele| Replies.new(ele) }
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
  end

  # def insert 
  #   raise "#{self} already in database" if self.id
  #   QuestionsDatabase.instance.execute(<<-SQL, self.body, self.title, self.author_id)
  #     INSERT INTO
  #       questions (body, title, author_id)
  #     VALUES
  #       (?, ?, ?)
  #   SQL
  #   self.id = QuestionsDatabase.instance.last_insert_row_id

  # end

end