import sys
import ssl
import yt_dlp 
import argparse

"""
Usage: python3 youtube-converter.py --link <link> [--help]

You can also add a playlist link.

Prequisites: FFmpeg and yt_dlp
- `brew install ffmpeg`
- `pip3 install yt-dlp`
"""

class YoutubeConverter:
  
  def __init__(self):
    print("[*] Welcome to Youtube Converter to MP3")
    ssl._create_default_https_context = ssl._create_stdlib_context
    self.parse_arguments()

  def parse_arguments(self):
    parser = argparse.ArgumentParser(description="A command line tool to convert Youtube videos to MP3",epilog="Example: youtube-converter.py --link <Youtube Link>")
    parser.add_argument('--link',type=str,help='Youtube video or playlist link to convert',required=True)
    parser.add_argument('-v','--version',action='version',version='YoutubeConverter 1.0')

    args = parser.parse_args()

    if args.link:
      self.convert_link(args.link)
    else: 
      print("[*] Use --help for more information")

  def convert_link(self,link):
    try:
      ydl_opts = {
        'format': 'm4a/bestaudio/best',
        'postprocessors': [{  # Extract audio using ffmpeg
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
        } ]
      }
      with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        ydl.download(link)
      
    except Exception as e:
      print(f"Error {e}")
if __name__ == '__main__':
  YoutubeConverter()