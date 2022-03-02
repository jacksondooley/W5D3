require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton
  
  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Users
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
  
    return nil unless users.length > 0

    Users.new(users.first)
  end

  def self.find_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND lname = ? -- IS THIS CORRECT?
    SQL

    return nil if users.length < 1

    Users.new(users.first)
  end

  def authored_replies
    Replies.find_by_user_id(self.id)
  end

  def authored_questions
    Questions.find_by_author_id(self.id)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

end

class Questions
  attr_accessor :id, :title, :body, :author_id

  def self.find_by_id(id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL

    return nil if questions.length < 1

    Questions.new(questions.first)
  end

  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        author_id = ?
    SQL

    return nil if questions.length < 1
    Questions.new(questions.first)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    author_class = Users.find_by_id(self.id)
    puts "#{author_class.fname} #{author_class.lname}"
  end

  def replies
    arr = Replies.find_by_question_id(self.id)
    arr.each do |el|
      print "#{el.body}, "
    end
  end
end

class QuestionFollows
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    question_follows = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL

    return nil if question_follows.length < 1

    QuestionFollows.new(question_follows.first)
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end

class Replies
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def self.find_by_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM 
        replies
      WHERE
        id = ?
    SQL

    return nil if replies.length < 1

    Replies.new(replies.first)
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
  SQL

  return nil if replies.length < 1

  Replies.new(replies.first)
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
  SQL
  
  return nil if replies.length < 1

  arr = []
    replies.each do |reply|
      arr << Replies.new(reply)
    end
    arr
  end

  def self.find_by_parent_reply_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT 
        *
      FROM 
        replies
      WHERE
        id = ?
    SQL

    return nil if replies.length < 1

    arr = []
    replies.each do |reply|
      arr << Replies.new(reply)
    end
    arr
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
  end

  def author
    author_class = Users.find_by_id(self.user_id)
    puts "#{author_class.fname} #{author_class.lname}"
  end

  def question
    question_class = Questions.find_by_id(self.question_id)
    puts "#{question_class.title} #{question_class.body}"
  end
  
  def parent_reply
    parent_class = Replies.find_by_id(self.parent_reply_id)
    print parent_class.body
  end

  def child_replies
    child_class = Replies.find_by_parent_reply_id(self.id)
    child_class.each do |el|
      puts el.body
    end
  end

end

class QuestionLikes
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    question_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      question_likes
    WHERE
      id = ?
  SQL

  return nil if question_likes.length < 1

  QuestionLikes.new(question_likes.first)

  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
