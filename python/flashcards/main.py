import tkinter
import pandas
import random

BACKGROUND_COLOR = "#B1DDC6"
current_card = {}
to_learn = {}
# ---------------- // FUNCTIONS // ----------------------- #


try:
    data = pandas.read_csv(filepath_or_buffer="./data/words_to_learn.csv")
except FileNotFoundError:
    original_data = pandas.read_csv("data/french_words.csv")
    to_learn = original_data.to_dict(orient="records")
else:
    to_learn = data.to_dict(orient="records")



def next_card():
    global current_card 
    current_card = random.choice(to_learn)
    canvas.itemconfig(card_title, text="French", fill="black")
    canvas.itemconfig(card_word, text=current_card["French"], fill="black")
    canvas.itemconfig(canvas_img, image=card_front)
    window.after(400, func=flip_card)


def flip_card():
    canvas.itemconfig(canvas_img, image=card_back)
    canvas.itemconfig(card_title, text="English")
    canvas.itemconfig(card_word, text=current_card["English"])
    
def is_known():
    to_learn.remove(current_card)
    data = pandas.DataFrame(to_learn)
    data.to_csv("data/words_to_learn.csv",index=False)
    next_card()

# ------------------------- // ---------------------------
# window settings
window = tkinter.Tk()
window.title("Flashy")
window.config(padx=50, pady=50, bg=BACKGROUND_COLOR)

# canvas
canvas = tkinter.Canvas(height=526, width=800)
canvas.config(bg=BACKGROUND_COLOR, highlightthickness=0)
canvas.grid(row=0, column=0, columnspan=2)

card_front = tkinter.PhotoImage(file="./images/card_front.png")
card_back = tkinter.PhotoImage(file="./images/card_back.png")
canvas_img = canvas.create_image(400, 263, image=card_front)

card_title = canvas.create_text(400, 150, text="Title", font=("Ariel", 40, "italic"))
card_word = canvas.create_text(400, 263, text="word", font=("Ariel", 60, "bold"))

cross_img = tkinter.PhotoImage(file="./images/wrong.png")
btn_wrong = tkinter.Button(image=cross_img, highlightthickness=0, command=next_card)
btn_wrong.grid(row=1, column=0)

right_img = tkinter.PhotoImage(file="./images/right.png")

btn_right = tkinter.Button(image=right_img, highlightthickness=0, command=is_known)
btn_right.grid(row=1, column=1)
next_card()
window.mainloop()
