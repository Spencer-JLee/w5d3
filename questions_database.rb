require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

   def initialize
    super('aa_questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end

class Users

  attr_accessor :id, :f_name, :l_name

  def self.find_by_id(id)
     user = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    return nil unless user.length > 0 
    Users.new(user.first)
  end


  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users")
    data.map { |datum| Users.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @f_name = options['f_name']
    @l_name = options['l_name']
  end

  def insert
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.f_name, self.l_name)
      INSERT INTO
        users (f_name, l_name)
      VALUES
        (?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.f_name, self.l_name, self.id)
      UPDATE
        users
      SET
        f_name = ?, l_name = ?
      WHERE
        id = ?
    SQL
  end

  def self.find_by_name(f_name, l_name)
    user = QuestionsDatabase.instance.execute(<<-SQL, f_name, l_name)
      SELECT
        *
      FROM
        users
      WHERE
        f_name = ? AND l_name = ?
    SQL
    return nil unless user.length > 0
    user.map { |ele| Users.new(ele) }
  end

  def authored_questions
    Questions.find_by_author(self.id)
  end

  def authored_replies
    Replies.find_by_user_id(self.id)
  end

end

