import os
import re
import json
from googleapiclient.discovery import build

id_counter = 1
api_key = os.getenv("YOUTUBE_API_KEY")

def extract_info_from_file(dart_file):
    with open(dart_file, 'r') as file:
        content = file.read()

    video_pattern = r'//\s*video\s*-\s*(.*)'
    widgets_pattern = r'//\s*widgets\s*-\s*(.*)'
    replace_pattern = r'//\s*replace\s*-\s*(\[{.*}\])'
    video = re.search(video_pattern, content)
    widgets = re.search(widgets_pattern, content)
    replace = re.search(replace_pattern, content)

    video = video.group(1).strip() if video else ''
    widgets = widgets.group(1).strip() if widgets else ''
    # try:
    replace = json.loads(replace.group(1).strip()) if replace else []
    # except json.JSONDecodeError as e:
    #     print("Error decoding JSON:", e)
    #     print("Invalid JSON object:", replace.group(1).strip())
    #     replace = []

    title, desc, embed = '', '', ''
    if video:
        youtube = build('youtube', 'v3', developerKey=api_key)
        video_id = re.search(r'(?<=v=)[^&#]+', video)
        video_id = video_id.group(0) if video_id else None

        if video_id:
            response = youtube.videos().list(
                part='snippet',
                id=video_id
            ).execute()

            if response and response['items']:
                title = response['items'][0]['snippet']['title']
                desc = response['items'][0]['snippet']['description']
                embed = f'https://www.youtube.com/embed/{video_id}'

    # Extract folder name from dart_file path
    folder = os.path.split(os.path.dirname(dart_file))[-1]

    result = {
        "video": video,
        "title": title,
        "desc": desc,
        "embed": embed,
        "widgets": widgets,
        "replace": replace,
        "folder": folder
    }

    return result

def main():
    global id_counter

    dart_files = []

    for root, dirs, files in os.walk('.'):
        for file in files:
            if file.endswith('.dart') or file.endswith('.js'):
                dart_files.append(os.path.join(root, file))

    # Load existing JSON data
    with open('gh-pages/data/data.json', 'r') as json_file:
        existing_data = json.load(json_file)

    # Update id_counter if existing_data is not empty
    if existing_data:
        id_counter = max(item.get('id', 0) for item in existing_data) + 1

    for dart_file in dart_files:
        info = extract_info_from_file(dart_file)

        if info.get('video') and info['video'].lower() != 'no' and 'www.youtube' in info['video']:
            # Convert the local path to a public GitHub path
            public_gh_path = f'https://github.com/bulgariamitko/flutterflowtutorials/blob/main/{dart_file[2:].replace(" ", "%20")}'

            # Check if the file path is already in the existing JSON data
            if any(item.get('file_path') == public_gh_path for item in existing_data):
                continue

            info['file_path'] = public_gh_path
            info['id'] = id_counter
            existing_data.append(info)
            id_counter += 1

    json_data = json.dumps(existing_data, indent=4)

    with open('gh-pages/data/data.json', 'w') as json_file:
        json_file.write(json_data)

if __name__ == '__main__':
    main()
