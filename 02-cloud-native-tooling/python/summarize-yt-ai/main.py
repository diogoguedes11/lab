from yt_dlp import YoutubeDL
import whisper 
from langchain_text_splitters import RecursiveCharacterTextSplitter


URL= 'https://www.youtube.com/watch?v=Y-pEoGvuWKk'
FILE_NAME="audio.mp3"
TRANSCRIPT_FILE="transcription.txt"

def get_transcript():
    print("Starting YouTube video summarization...")
    ydl_opts = {
        'format': 'bestaudio/best',
        'quiet': False,
        'no_warnings': False,
        'source_address': '0.0.0.0', 
        'extractor_args': {'youtube': {'player_client': ['android']}},
        'user_agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '192',
        }],
        'outtmpl': 'audio',
}
    with YoutubeDL(ydl_opts) as ydl:
        ydl.download(URL)
    print(f"Download finished:{FILE_NAME}") 
    model = whisper.load_model("base")
    result = model.transcribe(f"./{FILE_NAME}",fp16=False,verbose=True)
    with open(f"{TRANSCRIPT_FILE}", "w", encoding="utf-8") as f:
        f.write(result["text"]) 
    print("\n--- DONE! ---")

def summarize(document):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=100, chunk_overlap=0)
    texts = text_splitter.split_text(document)
    print(texts)


def main():
    get_transcript()
    summarize(document=TRANSCRIPT_FILE)

if __name__ == "__main__":
    main()