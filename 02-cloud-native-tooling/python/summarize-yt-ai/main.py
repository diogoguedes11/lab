from yt_dlp import YoutubeDL
import whisper 
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_core.documents import Document
from langchain_community.document_loaders.text import TextLoader

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
    #llm = Ollama(model="llama3")
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=2000, chunk_overlap=200)
    loader_docs = TextLoader(file_path=document, encoding='utf-8').load()
    docs = text_splitter.split_documents(loader_docs)
    print(docs)

    # map reduce for long texts
    # chain = load_summarize_chain(llm, chain_type="map_reduce")

    # print("--- Summary---")
    # summary = chain.run(docs)

def main():
    get_transcript()
    summarize(document=TRANSCRIPT_FILE)

if __name__ == "__main__":
    main()