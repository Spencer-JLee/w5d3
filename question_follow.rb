require_relative 'questions_database.rb'
require_relative 'questions.rb' 

class QuestionFollow 

  def self.followers_for_question_id(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT users.id, users.f_name, users.l_name FROM users 
      JOIN question_follows ON users.id = question_follows.user_id
      JOIN questions ON question_follows.question_id = questions.id   
      WHERE questions.id = ? 
    SQL
    return nil unless followers.length > 0 
    followers.map { |ele| Users.new(ele)}
  end

  def self.followed_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT questions.id, questions.body, questions.title, questions.author_id 
      FROM questions 
      JOIN question_follows ON questions.id = question_follows.question_id
      JOIN users ON question_follows.user_id = users.id   
      WHERE users.id = ? 
    SQL
    return nil unless questions.length > 0
    questions.map { |ele| Questions.new(ele)}
  end
end


