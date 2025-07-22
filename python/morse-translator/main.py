# https://en.wikipedia.org/wiki/Morse_code#/media/File:International_Morse_Code.svg

MORSE_CODE_DICT = {
     'A': '.-', 'B': '-...', 'C': '-.-.', 'D': '-..', 'E': '.', 'F': '..-.',
     'G': '--.', 'H': '....', 'I': '..', 'J': '.---', 'K': '-.-', 'L': '.-..',
     'M': '--', 'N': '-.', 'O': '---', 'P': '.--.', 'Q': '--.-', 'R': '.-.',
     'S': '...', 'T': '-', 'U': '..-', 'V': '...-', 'W': '.--', 'X': '-..-',
     'Y': '-.--', 'Z': '--..',
     '1': '.----', '2': '..---', '3': '...--', '4': '....-', '5': '.....',
     '6': '-....', '7': '--...', '8': '---..', '9': '----.', '0': '-----',
     ',': '--..--', '.': '.-.-.-', '?': '..--..', "'": '.----.', '!': '-.-.--',
     '/': '-..-.', '(': '-.--.', ')': '-.--.-', '&': '.-...', ':': '---...',
     ';': '-.-.-.', '=': '-...-', '+': '.-.-.', '-': '-....-', '_': '..--.-',
     '"': '.-..-.', '$': '...-..-', '@': '.--.-.'
}

def text_to_morse(msg: str) -> str:
     """
     Convert a text message to Morse code.
     Spaces are converted to '/'.
     Unknown characters are ignored.
     """
     morse_msg = []
     for char in msg:
          if char == ' ':
               morse_msg.append('/')
          else:
               code = MORSE_CODE_DICT.get(char.upper())
               if code:
                    morse_msg.append(code)
               # else: ignore unknown characters
     return ' '.join(morse_msg)

def main():
     """ Main function to run the Morse code translator. """
     msg = input("Send me a message you want to translate to Morse: ")
     print(text_to_morse(msg))

if __name__ == '__main__':
     main()