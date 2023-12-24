declare -A ServerType1=( ["Server1Name"]="Server1IP" ["Server2Name"]="Server2IP" ["Server3Name"]="Server3IP" )
declare -A ServerType2=( ["Server1Name"]="Server1IP" ["Server2Name"]="Server2IP" ["Server3Name"]="Server3IP"  )
declare -A ServerType3=( ["Server1Name"]="Server1IP" ["Server2Name"]="Server2IP" ["Server3Name"]="Server3IP" )
declare -A ServerType4=( ["Server1Name"]="Server1IP" ["Server2Name"]="Server2IP" ["Server3Name"]="Server3IP" )
declare -A ServerType5=( ["Server1Name"]="Server1IP" ["Server2Name"]="Server2IP" ["Server3Name"]="Server3IP" )
declare -A ServerType6=( ["Server1Name"]="Server1IP" ["Server2Name"]="Server2IP" ["Server3Name"]="Server3IP" )

# Define email parameters
TO="abc@companyxyz.com" 
FROM="no-reply@companyxyz.com"

# Initialize variable to store server down alerts
SERVER_DOWN_ALERTS=""

perform_health_check() {
    local SERVER_NAME="$1"
    local SERVER_IP="$2"
    local SERVER_URL="$3"

    # Check the health of the server and capture the response body
    local CHECK_RESULT=$(curl -s -o /tmp/health_check_output -w "%{http_code}" "$SERVER_URL")
    local RESPONSE_BODY=$(cat /tmp/health_check_output)

    if [ "$CHECK_RESULT" != "200" ] && [ "$CHECK_RESULT" != "503" ]; then
        # Server is down; append server information to the alerts
        SERVER_DOWN_ALERTS+="|$SERVER_NAME | $SERVER_IP | $SERVER_URL |\n\n"
    fi

    # Clean up temporary file
    rm -f /tmp/health_check_output
}

# Loop through each server IP address for the ServerType1 servers
for SERVER_NAME in "${!ServerType1[@]}"; do
    SERVER_IP="${ServerType1[$SERVER_NAME]}"
    SERVER_URL="http://${SERVER_IP}:Port/v1/common/healthcheck"
    perform_health_check "$SERVER_NAME" "$SERVER_IP" "$SERVER_URL"
done

# Loop through each server IP address for the ServerType2 servers
for SERVER_NAME in "${!ServerType2[@]}"; do
    SERVER_IP="${ServerType2[$SERVER_NAME]}"
    SERVER_URL="http://${SERVER_IP}:Port/v1/common/healthcheck"
    perform_health_check "$SERVER_NAME" "$SERVER_IP" "$SERVER_URL"
done

# Loop through each server IP address for the ServerType3 servers
for SERVER_NAME in "${!ServerType3[@]}"; do
    SERVER_IP="${ServerType3[$SERVER_NAME]}"
    SERVER_URL="http://${SERVER_IP}:Port/v1/healthcheck"
    perform_health_check "$SERVER_NAME" "$SERVER_IP" "$SERVER_URL"
done

# Loop through each server IP address for the ServerType4 servers
for SERVER_NAME in "${!ServerType4[@]}"; do
    SERVER_IP="${ServerType4[$SERVER_NAME]}"
    SERVER_URL="http://${SERVER_IP}:Port/health"
    perform_health_check "$SERVER_NAME" "$SERVER_IP" "$SERVER_URL"
done

# Loop through each server IP address for the ServerType5 servers
for SERVER_NAME in "${!ServerType5[@]}"; do
    SERVER_IP="${ServerType5[$SERVER_NAME]}"
    SERVER_URL="http://${SERVER_IP}:Port/healthcheck?pretty=true"
    perform_health_check "$SERVER_NAME" "$SERVER_IP" "$SERVER_URL"
done

# Loop through each server IP address for the ServerType6 servers
for SERVER_NAME in "${!ServerType6[@]}"; do
    SERVER_IP="${ServerType6[$SERVER_NAME]}"
    SERVER_URL="http://${SERVER_IP}:Port/healthcheck"
    perform_health_check "$SERVER_NAME" "$SERVER_IP" "$SERVER_URL"
done

# Send an email notification if there are server down alerts
if [ -n "$SERVER_DOWN_ALERTS" ]; then
    # Create email subject and message
    SUBJECT="QA/Staging Server Down Alert"
    EMAIL_MESSAGE="Server down alerts at $(date)\n\n| Server Name | Server IP | Server URL |\n\n$SERVER_DOWN_ALERTS"

    # Send the email without echoing anything
    echo -e "$EMAIL_MESSAGE" | mail -s "$SUBJECT" -r "$FROM" "$TO"
fi
