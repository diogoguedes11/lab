# This program allows us to run local LLMs on our machine (offline)
from gpt4all import GPT4All
model = GPT4All("orca-mini-3b-gguf2-q4_0.gguf") # open source model (size: 1.98GB)

session_enabled = True
while session_enabled:
     with model.chat_session():
          user_input = input("Ask anything: ")
          if user_input.lower() in ["exit", "quit"]:
               session_enabled = False
          else:
               response = model.generate(user_input, max_tokens=1024)
               print(f"Bot Response: {response}")