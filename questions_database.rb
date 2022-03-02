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

end

class Questions 

  attr_accessor :id, :body, :author_id, :title

   def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def self.find_by_id
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    return nil unless question.length > 0 
    Questions.new(question.first)
  end

  def initialize(options)
    @id = options['id']
    @body = options['body']
    @author_id = options['author_id']
    @title = options['title']
  end

  def insert 
    raise "#{self} already in database" if self.id
    QuestionsDatabase.instance.execute(<<-SQL, self.body, self.title, self.author_id)
      INSERT INTO
        questions (body, title, author_id)
      VALUES
        (?, ?, ?)
    SQL
    self.id = QuestionsDatabase.instance.last_insert_row_id

  end

end