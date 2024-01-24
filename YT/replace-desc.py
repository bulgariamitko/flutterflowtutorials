import os
import re
import json
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from google.auth.transport.requests import Request

# Define the scopes
SCOPES = ['https://www.googleapis.com/auth/youtube']

def replace_discord_link(description):
    old_link = 'https://discord.gg/ERDVFBkJmY'
    new_link = 'https://discord.gg/G69hSUqEeU'
    return description.replace(old_link, new_link)

def update_video_description(youtube, video_id, new_title, new_description, category_id):
    youtube.videos().update(
        part='snippet',
        body={
            'id': video_id,
            'snippet': {
                'title': new_title,
                'description': new_description,
                'categoryId': category_id
            }
        }
    ).execute()

def get_all_videos(youtube):
    request = youtube.channels().list(
        part="contentDetails",
        mine=True
    )
    response = request.execute()

    playlist_id = response['items'][0]['contentDetails']['relatedPlaylists']['uploads']
    videos = []

    next_page_token = None
    while True:
        playlist_request = youtube.playlistItems().list(
            part="snippet,contentDetails",
            playlistId=playlist_id,
            maxResults=50,
            pageToken=next_page_token
        )
        playlist_response = playlist_request.execute()

        videos += playlist_response['items']
        next_page_token = playlist_response.get('nextPageToken')

        if not next_page_token:
            break

    return videos

def get_video_details(youtube, video_id):
    response = youtube.videos().list(
        part="snippet",
        id=video_id
    ).execute()

    if response['items']:
        return response['items'][0]['snippet']
    else:
        return None

def main():
    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first time.
    if os.path.exists('token.json'):
        creds = Credentials.from_authorized_user_file('token.json', SCOPES)
    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                os.path.expanduser('credentials.json'), SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open('token.json', 'w') as token:
            token.write(creds.to_json())

    youtube = build('youtube', 'v3', credentials=creds)

    videos = get_all_videos(youtube)

    print(f"Found {len(videos)} videos.")

    for video in videos:
        video_id = video['snippet']['resourceId']['videoId']
        video_details = get_video_details(youtube, video_id)

        if video_details:
            original_title = video_details['title']
            original_description = video_details['description']
            category_id = video_details.get('categoryId')

            if category_id:
                new_description = replace_discord_link(original_description)

                if original_description != new_description:
                    update_video_description(youtube, video_id, original_title, new_description, category_id)
                else:
                    print(f"No change for video: {video_id}")
            else:
                print(f"Category ID not found for video: {video_id}")
        else:
            print(f"Details not found for video: {video_id}")

if __name__ == '__main__':
    main()
