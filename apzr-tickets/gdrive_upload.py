"""
Upload updated screenshots to Google Drive folders.
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

# Local screenshot base path (flat directory with all screenshots)
BASE_PATH = r'C:\Users\fabah\Advertising Product\kepler-ads-design\apzr-tickets\screenshots'

# Subfolder mapping: GDrive folder name -> list of (local_filename, display_name)
SUBFOLDERS = {
    'PROD-4120 - ASIN Setup Wizard': [
        ('PROD-4120-step1-product-selection.png', 'Step 1: Product Selection.png'),
        ('PROD-4120-step2-competitor-research.png', 'Step 2: Automated Competitor Research.png'),
        ('PROD-4120-step3-keyword-research.png', 'Step 3: Automated Keyword Research.png'),
        ('PROD-4120-step4-campaign-config.png', 'Step 4: Campaign Config.png'),
        ('PROD-4120-step5-activate.png', 'Step 5: Activate.png'),
    ],
    'PROD-4121 - IBO Bulk Launch': [
        ('PROD-4121-ibo-stage1.png', 'Stage 1: Mission Setup.png'),
    ],
    'PROD-4122 - Manage Ads': [
        ('PROD-4122-manage-ads.png', 'Manage Ads: ASIN Table.png'),
    ],
    'PROD-4123 - Dashboards': [
        ('PROD-4123-dashboard.png', 'Dashboard: Performance Overview.png'),
        ('PROD-4123-ads-performance.png', 'ADS Performance: ASIN Dashboard.png'),
    ],
    'PROD-4124 - Keyword Settings': [
        ('PROD-4124-keyword-settings.png', 'Keyword Settings: Full Table.png'),
    ],
    'PROD-4125 - Search Term Settings': [
        ('PROD-4125-search-term-settings.png', 'Search Term Settings: Active Terms.png'),
    ],
    'PROD-4126 - Campaigns and KW Research': [
        ('PROD-4126-campaigns.png', 'Campaign List.png'),
    ],
    'PROD-4127 - Pacing Bids Logs': [
        ('PROD-4127-bid-optimization.png', 'Bid Optimization Analytics.png'),
        ('PROD-4127-logs-change-log.png', 'Config Change Log.png'),
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


def find_or_create_subfolder(service, parent_id, folder_name):
    """Find a subfolder by name, or create it if it doesn't exist."""
    query = f"name='{folder_name}' and '{parent_id}' in parents and mimeType='application/vnd.google-apps.folder' and trashed=false"
    results = service.files().list(q=query, fields='files(id, name)').execute()
    files = results.get('files', [])
    if files:
        return files[0]['id']
    # Create the folder
    file_metadata = {
        'name': folder_name,
        'mimeType': 'application/vnd.google-apps.folder',
        'parents': [parent_id]
    }
    folder = service.files().create(body=file_metadata, fields='id').execute()
    print(f'  Created folder: {folder_name} (ID: {folder["id"]})')
    return folder['id']


def delete_existing_files(service, folder_id):
    """Delete all existing files in a folder (to replace with new ones)."""
    query = f"'{folder_id}' in parents and trashed=false"
    results = service.files().list(q=query, fields='files(id, name)').execute()
    files = results.get('files', [])
    for f in files:
        service.files().delete(fileId=f['id']).execute()
        print(f'  Deleted old: {f["name"]}')


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

        # Find or create the subfolder
        folder_id = find_or_create_subfolder(service, PARENT_FOLDER_ID, subfolder_name)
        print(f'  Folder ID: {folder_id}')

        # Delete old files in the folder
        delete_existing_files(service, folder_id)

        folder_links = []
        for local_name, display_name in files:
            file_path = os.path.join(BASE_PATH, local_name)
            if not os.path.exists(file_path):
                print(f'  WARNING: File not found: {file_path}')
                continue

            print(f'  Uploading: {display_name}...', end=' ')
            result = upload_file(service, folder_id, file_path, display_name)
            link = result.get('webViewLink', '')
            print(f'OK (ID: {result["id"]})')
            folder_links.append({
                'name': display_name,
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
        print(f'Sharing note: {e}\n')

    # Save results
    output_path = os.path.join(os.path.dirname(__file__), 'gdrive_links.json')
    with open(output_path, 'w') as f:
        json.dump(all_links, f, indent=2)
    print(f'Links saved to: {output_path}')

    # Print summary
    print('\n=== UPLOAD SUMMARY ===')
    total = 0
    for subfolder_name, data in all_links.items():
        ticket = subfolder_name.split(' - ')[0]
        print(f'\n{ticket} ({subfolder_name}):')
        print(f'  Folder: https://drive.google.com/drive/folders/{data["folder_id"]}')
        for f in data['files']:
            print(f'  - {f["name"]}')
            print(f'    {f["webViewLink"]}')
            total += 1
    print(f'\nTotal files uploaded: {total}')


if __name__ == '__main__':
    main()
