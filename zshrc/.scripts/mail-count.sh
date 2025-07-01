#!/bin/sh

# Gmail unread count script
# Requires: curl, jq

# Configuration
CONFIG_DIR="$HOME/.config/mail-notify"
TOKEN_FILE="$CONFIG_DIR/token.json"
CREDENTIALS_FILE="$CONFIG_DIR/credentials.json"

# Function to get access token using refresh token
refresh_access_token() {
    if [[ ! -f "$CREDENTIALS_FILE" ]]; then
        echo "ERROR: Credentials file not found at $CREDENTIALS_FILE"
        exit 1
    fi

    # Extract credentials (handle both formats)
    local client_id client_secret
    if jq -e '.installed' "$CREDENTIALS_FILE" >/dev/null 2>&1; then
        client_id=$(jq -r '.installed.client_id' "$CREDENTIALS_FILE")
        client_secret=$(jq -r '.installed.client_secret' "$CREDENTIALS_FILE")
    else
        client_id=$(jq -r '.client_id' "$CREDENTIALS_FILE")
        client_secret=$(jq -r '.client_secret' "$CREDENTIALS_FILE")
    fi

    local refresh_token=$(jq -r '.refresh_token' "$TOKEN_FILE" 2>/dev/null)

    if [[ -z "$refresh_token" || "$refresh_token" == "null" ]]; then
        echo "ERROR: No refresh token found. Please run authentication first."
        exit 1
    fi

    local response=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$client_id&client_secret=$client_secret&refresh_token=$refresh_token&grant_type=refresh_token" \
        "https://oauth2.googleapis.com/token")

    local access_token=$(echo "$response" | jq -r '.access_token')
    
    if [[ -z "$access_token" || "$access_token" == "null" ]]; then
        echo "ERROR: Failed to refresh access token"
        exit 1
    fi

    echo "$access_token"
}

# Function to get unread email count
get_unread_count() {
    local access_token="$1"
    local query="is:unread in:inbox"
    
    # Get count of unread messages
    local response=$(curl -s -H "Authorization: Bearer $access_token" \
        "https://gmail.googleapis.com/gmail/v1/users/me/messages?q=$(echo "$query" | sed 's/ /%20/g')")
    
    local count=$(echo "$response" | jq -r '.resultSizeEstimate // 0')
    echo "$count"
}

# Main execution
main() {
    # Check if required tools are available
    for tool in curl jq; do
        if ! command -v "$tool" &> /dev/null; then
            echo "ERROR: $tool is not installed"
            exit 1
        fi
    done

    # Get access token
    local access_token=$(refresh_access_token)
    
    # Get and display unread count
    local count=$(get_unread_count "$access_token")
    if [[ $count -eq 0 ]]; then
        alt="none"
    else
        alt="unread"
    fi
    echo "{ \"text\": \"$count\", \"alt\": \"$alt\", \"tooltip\": \"$count new mails\" }"
}

main
