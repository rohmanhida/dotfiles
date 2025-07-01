#!/bin/sh

# mail notification script for swaync/dunst
# Requires: curl, jq, libnotify

# Configuration
CONFIG_DIR="$HOME/.config/mail-notify"
TOKEN_FILE="$CONFIG_DIR/token.json"
CREDENTIALS_FILE="$CONFIG_DIR/credentials.json"
LAST_CHECK_FILE="$CONFIG_DIR/last_check"
LOG_FILE="$CONFIG_DIR/gmail-notify.log"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Function to get access token using refresh token
refresh_access_token() {
    if [[ ! -f "$CREDENTIALS_FILE" ]]; then
        log "ERROR: Credentials file not found at $CREDENTIALS_FILE"
        echo "Please set up Gmail API credentials first."
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
        log "ERROR: No refresh token found. Please run initial setup."
        echo "Please run the setup process first to get refresh token."
        exit 1
    fi

    local response=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$client_id&client_secret=$client_secret&refresh_token=$refresh_token&grant_type=refresh_token" \
        "https://oauth2.googleapis.com/token")

    local access_token=$(echo "$response" | jq -r '.access_token')
    
    if [[ -z "$access_token" || "$access_token" == "null" ]]; then
        log "ERROR: Failed to refresh access token"
        echo "Failed to refresh access token. Response: $response"
        exit 1
    fi

    echo "$access_token"
}

# Function to get unread emails
get_unread_emails() {
    local access_token="$1"
    local query="is:unread in:inbox"
    
    # Get list of unread message IDs
    local messages_response=$(curl -s -H "Authorization: Bearer $access_token" \
        "https://gmail.googleapis.com/gmail/v1/users/me/messages?q=$(echo "$query" | sed 's/ /%20/g')")
    
    local message_ids=$(echo "$messages_response" | jq -r '.messages[]?.id // empty')
    
    if [[ -z "$message_ids" ]]; then
        log "No unread messages found"
        return 0
    fi

    # Get last check timestamp
    local last_check=0
    if [[ -f "$LAST_CHECK_FILE" ]]; then
        last_check=$(cat "$LAST_CHECK_FILE")
    fi

    local new_messages=0
    local senders=()

    # Check each message
    while IFS= read -r message_id; do
        [[ -z "$message_id" ]] && continue
        
        local message_response=$(curl -s -H "Authorization: Bearer $access_token" \
            "https://gmail.googleapis.com/gmail/v1/users/me/messages/$message_id?format=metadata&metadataHeaders=From&metadataHeaders=Date")
        
        # Extract timestamp (internalDate is in milliseconds)
        local internal_date=$(echo "$message_response" | jq -r '.internalDate // "0"')
        local message_timestamp=$((internal_date / 1000))  # Convert to seconds
        
        # Check if message is newer than last check
        if [[ $message_timestamp -gt $last_check ]]; then
            # Extract sender
            local sender=$(echo "$message_response" | jq -r '.payload.headers[] | select(.name=="From") | .value')
            
            # Extract just the name or email from "Name <email>" format
            local sender_name=$(echo "$sender" | sed 's/.*<\(.*\)>.*/\1/' | sed 's/.*"\(.*\)".*/\1/')
            if [[ "$sender_name" == "$sender" ]]; then
                # If no name extraction worked, try to get just the part before <
                sender_name=$(echo "$sender" | sed 's/\(.*\) <.*/\1/' | sed 's/^"//;s/"$//')
            fi
            
            senders+=("$sender_name")
            ((new_messages++))
        fi
    done <<< "$message_ids"

    # Send notification if there are new messages
    if [[ $new_messages -gt 0 ]]; then
        local notification_body
        if [[ $new_messages -eq 1 ]]; then
            notification_body="New email from: ${senders[0]}"
        elif [[ $new_messages -le 3 ]]; then
            notification_body="New emails from: $(IFS=', '; echo "${senders[*]}")"
        else
            notification_body="$new_messages new emails from: $(IFS=', '; echo "${senders[@]:0:3}")..."
        fi


        # Send notification to swaync/dunst
        notify-send -a "mail" "$notification_body" -i /usr/share/icons/AdwaitaLegacy/48x48/legacy/emblem-mail.png
        log "Sent notification: $notification_body"
    fi

    # Update last check timestamp
    date +%s > "$LAST_CHECK_FILE"
}

# Main execution
main() {
    log "Starting Gmail check"
    
    # Check if required tools are available
    for tool in curl jq notify-send; do
        if ! command -v "$tool" &> /dev/null; then
            log "ERROR: $tool is not installed"
            echo "Please install $tool"
            exit 1
        fi
    done

    # Get access token
    local access_token=$(refresh_access_token)
    
    # Get and process unread emails
    get_unread_emails "$access_token"
    
    log "Gmail check completed"
}

# Setup function (run separately)
setup() {
    echo "Gmail API Setup"
    echo "==============="
    echo "1. Go to https://console.cloud.google.com/"
    echo "2. Create a new project or select existing one"
    echo "3. Enable Gmail API (Go to 'APIs & Services' > 'Library' > search 'Gmail API')"
    echo "4. Go to 'APIs & Services' > 'Credentials'"
    echo "5. Click '+ CREATE CREDENTIALS' > 'OAuth client ID'"
    echo "6. If prompted, configure OAuth consent screen first (Internal/External)"
    echo "7. Choose 'Desktop application' as application type"
    echo "8. Download the JSON file (it will be named like 'client_secret_xxx.json')"
    echo ""
    echo "Place the downloaded file at: $CREDENTIALS_FILE"
    echo ""
    echo "The downloaded file should contain a structure like:"
    echo '{"installed":{"client_id":"...","client_secret":"..."}}'
    echo ""
    echo "Then run: $0 auth"
}

# Authentication function
authenticate() {
    if [[ ! -f "$CREDENTIALS_FILE" ]]; then
        echo "Credentials file not found. Run: $0 setup"
        exit 1
    fi

    # Check if credentials file has the right format
    if ! jq empty "$CREDENTIALS_FILE" 2>/dev/null; then
        echo "ERROR: Invalid JSON in credentials file"
        exit 1
    fi

    # Try to extract credentials from different possible formats
    local client_id client_secret
    
    # Check if it's a downloaded OAuth client file (has 'installed' key)
    if jq -e '.installed' "$CREDENTIALS_FILE" >/dev/null 2>&1; then
        client_id=$(jq -r '.installed.client_id' "$CREDENTIALS_FILE")
        client_secret=$(jq -r '.installed.client_secret' "$CREDENTIALS_FILE")
    else
        # Direct format
        client_id=$(jq -r '.client_id' "$CREDENTIALS_FILE")
        client_secret=$(jq -r '.client_secret' "$CREDENTIALS_FILE")
    fi

    # Validate credentials
    if [[ -z "$client_id" || "$client_id" == "null" ]]; then
        echo "ERROR: client_id not found in credentials file"
        echo "Please check your credentials.json file format"
        exit 1
    fi

    if [[ -z "$client_secret" || "$client_secret" == "null" ]]; then
        echo "ERROR: client_secret not found in credentials file"
        echo "Please check your credentials.json file format"
        exit 1
    fi

    echo "Using client_id: ${client_id:0:20}..."
    
    echo "Open this URL in your browser:"
    echo "https://accounts.google.com/o/oauth2/auth?client_id=$client_id&redirect_uri=urn:ietf:wg:oauth:2.0:oob&scope=https://www.googleapis.com/auth/gmail.readonly&response_type=code"
    echo ""
    echo -n "Enter the authorization code: "
    read -r auth_code

    local response=$(curl -s -X POST \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "client_id=$client_id&client_secret=$client_secret&code=$auth_code&grant_type=authorization_code&redirect_uri=urn:ietf:wg:oauth:2.0:oob" \
        "https://oauth2.googleapis.com/token")

    echo "$response" > "$TOKEN_FILE"
    
    if echo "$response" | jq -e '.refresh_token' > /dev/null; then
        echo "Authentication successful! Token saved to $TOKEN_FILE"
    else
        echo "Authentication failed. Response: $response"
        exit 1
    fi
}

# Handle command line arguments
case "${1:-}" in
    "setup")
        setup
        ;;
    "auth")
        authenticate
        ;;
    *)
        main
        ;;
esac
