import argparse
import hashlib
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
          print(f"Initializing: {args.filepath}")
          with open(args.filepath,'rb') as f:
               digest = hashlib.file_digest(f,"sha256")
               hash_value = digest.hexdigest()
    elif args.command == 'check':
        print(f"Checking: {args.filepath}")

    elif args.command == 'update':
        print(f"Updating: {args.filepath}")

if __name__ == "__main__":
    main()
