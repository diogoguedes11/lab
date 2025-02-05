from youtube_transcript_api import YouTubeTranscriptApi
import requests
import json
from dotenv import load_dotenv


video_id = "9VlvbpXwLJs"
 # load variables from .env file
api_key = "<YOUR_API_KEY>"
# Check if both API key and video ID are provided
if api_key and video_id:
    try:
        # Fetching the transcript
        transcript_list = YouTubeTranscriptApi.get_transcript(video_id)
        full_transcript = " ".join([t['text'] for t in transcript_list])

        # Connect to the ChatGPT API
        endpoint = 'https://api.openai.com/v1/chat/completions'
        headers = {
            'Authorization': f'Bearer {api_key}',
            'Content-Type': 'application/json'
        }

        data = {
            'model': 'gpt-3.5-turbo',  # or the model of your choice
            'messages': [{'role': 'user', 'content': f'Summarize: {full_transcript}'}],
            'max_tokens': 4000 # change this to whatever you want
        }

        # Send the transcript to ChatGPT for summarization
        response = requests.post(endpoint, headers=headers, data=json.dumps(data))
        # Check if the response is successful
        if response.status_code == 200:
            # Extracting the summary from the response
            json_response = response.json()
            summary = json_response['choices'][0]['message']['content'].strip()
            print("Summary:\n")
            print(summary)
    except Exception as e:
        print(e.message)
