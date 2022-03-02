require_relative 'questions_database.rb'

class Questions 

  attr_accessor :id, :body, :author_id, :title

   def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
    data.map { |datum| Questions.new(datum) }
  end

  def self.find_by_id(id)
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

  def self.find_by_author(author_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT 
      *
    FROM
      questions
    WHERE 
      author_id = ? 
    SQL
    return nil unless question.length > 0 
    question.map { |ele| Questions.new(ele)}
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

  def author
    Users.find_by_id(self.id)
  end

  def replies
    Replies.find_by_question_id(self.id)
  end



end