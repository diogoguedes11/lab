from question_model import Question
from data import question_data
from quiz_brain import QuizBrain
question_bank = []

for question in question_data["results"]:
  question_text = question["question"]
  question_answer = question["correct_answer"]
  new_question = Question(question_text,question_answer)
  question_bank.append(new_question)
  

quizz = QuizBrain(question_bank)
while quizz.still_has_questions():
  quizz.next_question()
  
print("You've completed the quizz")
print(f"Your final score was: {quizz.score}/{quizz.question_number}")