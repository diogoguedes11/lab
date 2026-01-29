from yt_dlp import YoutubeDL
import whisper 


URL= 'https://www.youtube.com/watch?v=21mDekTZwsw'
def main():
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
        'outtmpl': 'audio_transcrever',
}
    with YoutubeDL(ydl_opts) as ydl:
        ydl.download(URL)
    print("Download finished: audio_transcrever.mp3")
    model = whisper.load_model("base")
    result = model.transcribe("./audio_transcrever.mp3",fp16=False)
    print(result["text"])

if __name__ == "__main__":
    main()