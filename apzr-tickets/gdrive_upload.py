"""
Upload screenshots to Google Drive folders and share with Kepler Commerce.
Uses existing OAuth credentials from MCP gdrive config.
"""
import json
import os
import sys
from google.oauth2.credentials import Credentials
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

SCOPES = ['https://www.googleapis.com/auth/drive']
CREDS_FILE = r'C:\Users\fabah\.config\mcp-gdrive\credentials.json'
TOKEN_FILE = r'C:\Users\fabah\.config\mcp-gdrive\gdrive-upload-token.json'

PARENT_FOLDER_ID = '1rgNL8oa-kA0TOYNrKBqHVZMQ8IhVySMN'  # Advertisement UI-UX folder

# Local screenshot base path
BASE_PATH = r'C:\Users\fabah\Advertising Product\kepler-ads-design\apzr-tickets\Advertisement UI-UX'

# Subfolder mapping: local folder name -> files
SUBFOLDERS = {
    'PROD-4120 — ASIN Setup Wizard': [
        'Step 1 — Product & Global Settings.png',
        'Step 2 — Competitor Research.png',
        'Step 3 — Generate Keyword Research.png',
        'Step 4 — KW Automation Review.png',
        'Step 5 — Campaign Configuration.png',
        'Step 6 — Activate Campaigns.png',
    ],
    'PROD-4121 — IBO Bulk Launch': [
        'Stage 1 — Mission Setup (Empty).png',
        'Stage 1 — AI Grouping Results.png',
        'Stage 2 — Per-Group Config with Auto Competitors.png',
        'Stage 3 — Async Processing (In Progress).png',
        'Stage 3 — All Processing Complete.png',
        'Stage 4 — Review Hub.png',
        'Stage 5 — Campaign Configuration.png',
        'Stage 6 — Launch Confirmation.png',
    ],
    'PROD-4122 — ASIN Overview': [
        'ASIN Overview — Status Table with Setup Badges.png',
    ],
    'PROD-4123 — Dashboards': [
        'Dashboard — KPI Cards, AI Recommendations, Budget Pacing.png',
    ],
    'PROD-4124 — Keyword Settings': [
        'Keyword Settings — Full Table with Column Groups.png',
    ],
    'PROD-4125 — Search Term Settings': [
        'Search Term Settings — Active Terms with Sub-Tabs.png',
    ],
    'PROD-4126 — Campaign Mgmt & KW Research': [
        'Campaign Config — Inline Editable Table.png',
        'Keyword Research — Search Volume & Bid Data.png',
    ],
    'PROD-4127 — Pacing & Bid Optimization': [
        'Pacing Management — Auto Pacing & Budget Allocation.png',
        'Bid Optimization — Analytics & Trends.png',
    ],
    'PROD-4128 — UX Infrastructure': [
        'Notification Bell — Dynamic Dropdown Panel.png',
    ],
}


def get_credentials():
    """Get or refresh OAuth credentials with full drive scope."""
    creds = None
    if os.path.exists(TOKEN_FILE):
        with open(TOKEN_FILE, 'r') as f:
            token_data = json.load(f)
        creds = Credentials.from_authorized_user_info(token_data, SCOPES)

    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(CREDS_FILE, SCOPES)
            creds = flow.run_local_server(port=0)

        # Save token
        with open(TOKEN_FILE, 'w') as f:
            json.dump(json.loads(creds.to_json()), f)

    return creds


def find_subfolder(service, parent_id, folder_name):
    """Find a subfolder by name under a parent folder."""
    query = f"name='{folder_name}' and '{parent_id}' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false"
    results = service.files().list(q=query, fields='files(id, name)').execute()
    files = results.get('files', [])
    return files[0]['id'] if files else None


def upload_file(service, folder_id, file_path, file_name):
    """Upload a file to a Google Drive folder."""
    file_metadata = {
        'name': file_name,
        'parents': [folder_id]
    }
    media = MediaFileUpload(file_path, mimetype='image/png', resumable=True)
    file = service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id, webViewLink, webContentLink'
    ).execute()
    return file


def share_folder(service, folder_id, domain):
    """Share a folder with an entire domain."""
    permission = {
        'type': 'domain',
        'role': 'reader',
        'domain': domain
    }
    service.permissions().create(
        fileId=folder_id,
        body=permission,
        sendNotificationEmail=False
    ).execute()


def main():
    print('Authenticating with Google Drive...')
    creds = get_credentials()
    service = build('drive', 'v3', credentials=creds)
    print('Authenticated successfully!\n')

    # Track all uploaded file links
    all_links = {}

    for subfolder_name, files in SUBFOLDERS.items():
        print(f'Processing: {subfolder_name}')

        # Find the subfolder
        folder_id = find_subfolder(service, PARENT_FOLDER_ID, subfolder_name)
        if not folder_id:
            print(f'  WARNING: Subfolder not found: {subfolder_name}')
            continue

        print(f'  Found folder ID: {folder_id}')
        folder_links = []

        for file_name in files:
            file_path = os.path.join(BASE_PATH, subfolder_name, file_name)
            if not os.path.exists(file_path):
                print(f'  WARNING: File not found: {file_path}')
                continue

            print(f'  Uploading: {file_name}...', end=' ')
            result = upload_file(service, folder_id, file_path, file_name)
            link = result.get('webViewLink', '')
            print(f'OK (ID: {result["id"]})')
            folder_links.append({
                'name': file_name,
                'id': result['id'],
                'webViewLink': link
            })

        all_links[subfolder_name] = {
            'folder_id': folder_id,
            'files': folder_links
        }
        print()

    # Share the parent folder with Kepler Commerce domain
    print('Sharing "Advertisement UI-UX" folder with keplercommerce.com...')
    try:
        share_folder(service, PARENT_FOLDER_ID, 'keplercommerce.com')
        print('Shared successfully!\n')
    except Exception as e:
        print(f'Sharing error: {e}\n')

    # Save results
    output_path = os.path.join(os.path.dirname(__file__), 'gdrive_links.json')
    with open(output_path, 'w') as f:
        json.dump(all_links, f, indent=2)
    print(f'Links saved to: {output_path}')

    # Print summary
    print('\n=== UPLOAD SUMMARY ===')
    total = 0
    for subfolder_name, data in all_links.items():
        ticket = subfolder_name.split(' — ')[0]
        print(f'\n{ticket} ({subfolder_name}):')
        print(f'  Folder: https://drive.google.com/drive/folders/{data["folder_id"]}')
        for f in data['files']:
            print(f'  - {f["name"]}')
            print(f'    {f["webViewLink"]}')
            total += 1
    print(f'\nTotal files uploaded: {total}')


if __name__ == '__main__':
    main()
