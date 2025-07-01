import argparse
import hashlib
import os
import subprocess
from pathlib import Path
SECURE_LOCATION = Path("/tmp/secure")

def compute_file_hash(filepath: Path) -> str:
     """Compute the SHA-256 hash of a file."""
     with open(filepath,'rb') as f:
               file_name = f.name.split("/")[-1]
               digest = hashlib.file_digest(f,"sha256")
               return digest.hexdigest() 

def get_hash_file_path(file_path: Path) -> Path:
    """Return the full path to the stored hash file in the secure directory."""
    return SECURE_LOCATION / file_path.name

def init(filepath: Path):
     try:
          hash_value = compute_file_hash(filepath)
          SECURE_LOCATION.mkdir(parents=True,exist_ok=True)
          hash_file_path = get_hash_file_path(filepath)
          hash_file_path.write_text(hash_value)
          print("Hashes stored successfully.")
     except FileNotFoundError:
        print("Error: file not found")
     except Exception as e:
        print(f"Error: {e}")

def check(filepath: Path):
    try:
          hash_value = compute_file_hash(filepath)

          hash_file_path = get_hash_file_path(filepath)

          if not hash_file_path.exists():
            print("Error: No stored hash to compare with. Run 'init' first.")
            return

          stored_hash = hash_file_path.read_text().strip()
          if hash_value.strip() == stored_hash.strip():
            print("Status: Hash match!")
          else:
            print("Status: Modified (Hash mismatch)")
    except Exception as e:
        print(f"Error: {e}")

def update(filepath: Path) -> None:
     try:
          hash_file_path = get_hash_file_path(filepath)
          if not hash_file_path.exists():
              print("Error: no stored hash to update. Run 'init' first." )
              return
          hash_value = compute_file_hash(filepath)
          if hash_file_path.write_text(hash_value):
              print("Hash updated succesfully.")
     except FileExistsError:
         print("File does not exist.")


def main():
     parser = argparse.ArgumentParser(
        prog='File checker',
        description='Verifies the integrity of the file'
    )

     subparsers = parser.add_subparsers(dest='command', required=True, help='Sub-command to run (init, check, update)')

    # init command
     init_parser = subparsers.add_parser('init', help='Initialize the file')
     init_parser.add_argument('filepath', help='Path to the file to initialize')

    # check command
     check_parser = subparsers.add_parser('check', help='Check the file integrity')
     check_parser.add_argument('filepath', help='Path to the file to check')

    # update command
     update_parser = subparsers.add_parser('update', help='Update the file integrity info')
     update_parser.add_argument('filepath', help='Path to the file to update')
     args = parser.parse_args()

     if args.command == 'init':
         init(Path(args.filepath))
     if args.command == 'check':
         check(Path(args.filepath))
     if args.command == 'update':
         update(Path(args.filepath))
if __name__ == "__main__":
    main()
