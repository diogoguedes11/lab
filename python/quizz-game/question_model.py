class Question:
  def __init__(self,text,answer) -> None:
    self.text = text
    self.answer = answer
    
    
new_q = Question("texto","True")

print(new_q.answer)