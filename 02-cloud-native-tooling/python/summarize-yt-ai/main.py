import yt_dlp
from yt_dlp import YoutubeDL

URL= 'https://www.youtube.com/watch?v=jkFal52bznw'
def main():
    print("Starting YouTube video summarization...")
    ydl_opts = {
        'format': 'bestaudio/best',
        'user_agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
            'preferredquality': '192',
        }],
        'outtmpl': 'audio_transcrever.%(ext)s'
    }
    with YoutubeDL(ydl_opts) as ydl:
        ydl.download(URL)
    print("Download concluído: audio_transcrever.mp3")

if __name__ == "__main__":
    main()