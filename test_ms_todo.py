import json, urllib.request, sys
import xml.etree.ElementTree as ET

# Read shared prefs xml
with open("shared_prefs.xml", "r") as f:
    xml_data = f.read()

root = ET.fromstring(xml_data)
token_json_str = ""
for child in root:
    if child.attrib.get("name") == "flutter.ms_todo_credentials":
        token_json_str = child.text

if not token_json_str:
    print("No credentials found")
    sys.exit(1)

creds = json.loads(token_json_str)
access_token = creds.get("accessToken")

# Fetch lists
req = urllib.request.Request("https://graph.microsoft.com/v1.0/me/todo/lists")
req.add_header("Authorization", "Bearer " + access_token)
try:
    with urllib.request.urlopen(req) as response:
        lists_data = json.loads(response.read().decode())
except urllib.error.HTTPError as e:
    print(f"Error fetching lists: {e.read().decode()}")
    sys.exit(1)

lists = lists_data.get("value", [])
for lst in lists:
    print(f"List: {lst['displayName']} (ID: {lst['id']})")
    # Fetch tasks
    req_tasks = urllib.request.Request(f"https://graph.microsoft.com/v1.0/me/todo/lists/{lst['id']}/tasks?$filter=status ne 'completed'")
    req_tasks.add_header("Authorization", "Bearer " + access_token)
    try:
        with urllib.request.urlopen(req_tasks) as t_response:
            tasks_data = json.loads(t_response.read().decode())
            for t in tasks_data.get("value", []):
                print(f"  - Task: {t['title']} (status: {t['status']})")
    except urllib.error.HTTPError as e:
         print(f"  Error fetching tasks: {e.read().decode()}")

