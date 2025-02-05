# Retrive pokemons
# Create a notion table with name and power

import requests
import os

POKEAPI_URL = "https://pokeapi.co/api/v2/"
NUMBER_OF_POKEMONS = 100
NOTION_URL = "https://api.notion.com/v1/pages"
NOTION_TOKEN = os.environ.get("NOTION_TOKEN")
DATABASE_ID = os.environ.get("DATABASE_ID")
POKEMON_IMAGE = "https://img.pokemondb.net/artwork/"

headers = {
    "Authorization": "Bearer " + NOTION_TOKEN,
    "Content-Type": "application/json",
    "Notion-Version": "2022-06-28",
}


def create_page(data: dict):
    """
    Create new page in NOtion
    """
    payload = {"parent": {"database_id": DATABASE_ID}, "properties": data}
    try:
        res = requests.post(NOTION_URL, headers=headers, json=payload)
        res.raise_for_status()
    except requests.exceptions.RequestException as e:
        print(f"Failed to create a page {e}")
        return None
    return res.json()


def get_pokemons(NUMBER_OF_POKEMONS):
    """
    Retrieve Pokemons
    """
    try:
        response = requests.get(f"{POKEAPI_URL}pokemon?limit={NUMBER_OF_POKEMONS}")
        response.raise_for_status()

    except requests.exceptions.RequestException as e:
        print(f"Failed to get pokemons {e}")
        return None
    return response.json().get("results", [])


def get_pokemon_details(url):
    try:
        response = requests.get(url)
        response.raise_for_status()
    except requests.exceptions.RequestException as e:
        print("Failed to retrieve pokemon details {e}")
        return None
    return response.json()


def main():

    pokemons = get_pokemons(NUMBER_OF_POKEMONS)
    if not pokemons:
        print("No pokemon found")
        return

    for pokemon in pokemons:
        pokemon_name = pokemon["name"]
        pokemon_url = pokemon["url"]

        pokemon_data = get_pokemon_details(pokemon_url)
        if not pokemon_data:
            print("No pokemon details")
            return

        abilities = [
            ability["ability"]["name"] for ability in pokemon_data["abilities"]
        ]
        data = {
            "Name": {"title": [{"text": {"content": pokemon_name}}]},
            "Abilities": {"rich_text": [{"text": {"content": ", ".join(abilities)}}]},
            "Image": {
                "files": [
                    {
                        "name": pokemon_name + "_image",
                        "type": "external",  # Specifies that the image is an external URL
                        "external": {
                            "url": f"{POKEMON_IMAGE}{pokemon_name}.jpg"  # Replace with the actual image URL
                        },
                    }
                ]
            },
        }
        create_page(data)
        print(f"Added Pokémon {pokemon_name} with abilities: {', '.join(abilities)}")


# table PHOTO, Pokemon name and abilities

if __name__ == "__main__":
    main()
