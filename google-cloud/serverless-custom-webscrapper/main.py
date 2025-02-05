import requests
from bs4 import BeautifulSoup
import re
from flask import jsonify

def scrape_data():
    try:
        url = 'https://www.nba.com/stats'
        response = requests.get(url)
        response.raise_for_status()  # Raise an error for bad responses
        
        # Use BeautifulSoup to parse the HTML
        soup = BeautifulSoup(response.text, 'html.parser')
        
        # Find leaderboard titles and top players
        leaderboard_titles = soup.findAll(class_="LeaderBoardCard_lbcTitle___WI9J")
        player_rows = soup.findAll(class_="LeaderBoardPlayerCard_lbpcTableRow___Lod5")

        # Prepare a list to hold results
        data = []

        # Iterate through titles and players together
        for player_row, leaderboard_title in zip(player_rows, leaderboard_titles):
            player_text = player_row.get_text(strip=True)
            
            # Only process players ranked 1
            if player_text.startswith('1'):  # Checks if the first character is '1'
                # Extract leaderboard title and top player info
                title = leaderboard_title.get_text(strip=True)
                name_match = re.search(r'\d+\.(\w+\s\w+)', player_text)
                if name_match:
                    player_info = name_match.group(1)
                    # Append the data to the list
                    data.append({
                        "leaderboard_title": title,
                        "top_player_info": player_info
                    })

        return data

    except Exception as e:
        return jsonify({"error": str(e)}), 500  # Return error message

def nba_leaderboard_scrape(request):
    # Scrape the data
    scraped_data = scrape_data()
    
    # Return the data as a JSON response
    return jsonify(scraped_data)