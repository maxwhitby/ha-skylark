#!/bin/bash
# Hardcoded credentials version for Home Assistant compatibility

# PythonAnywhere credentials
PA_USERNAME="maxwhitby"
PA_TOKEN="b1be3442c535d026367328ee49b9ba4d51200624"
PA_PATH="/home/maxwhitby/mysite/static"

# Validate input arguments
if [ $# -ne 14 ]; then
    echo "Error: Expected 14 arguments, got $#" >&2
    echo "Usage: $0 SOLAR IMPORT LOAD BATTERY SOLAR_NOW IMPORT_NOW LOAD_NOW BATTERY_CHARGE BATTERY_DISCHARGE CELL_DIFF IMMERSION_UPPER IMMERSION_LOWER BATTERY_VOLTAGE DVCC_MAX_CURRENT" >&2
    exit 1
fi

# Get the values passed as arguments
SOLAR=$1
IMPORT=$2
LOAD=$3
BATTERY=$4
SOLAR_NOW=$5
IMPORT_NOW=$6
LOAD_NOW=$7
BATTERY_CHARGE=$8
BATTERY_DISCHARGE=$9
CELL_DIFF=${10}
IMMERSION_UPPER=${11}
IMMERSION_LOWER=${12}
BATTERY_VOLTAGE=${13}
DVCC_MAX_CURRENT=${14}

# Validate numeric inputs
for value in "$SOLAR" "$IMPORT" "$LOAD" "$BATTERY" "$SOLAR_NOW" "$IMPORT_NOW" "$LOAD_NOW" "$BATTERY_CHARGE" "$BATTERY_DISCHARGE" "$CELL_DIFF" "$IMMERSION_UPPER" "$IMMERSION_LOWER" "$BATTERY_VOLTAGE" "$DVCC_MAX_CURRENT"; do
    if ! [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
        echo "Error: Invalid numeric value: $value" >&2
        exit 1
    fi
done

# Path is already set above with hardcoded credentials

# Generate timestamp in YYYYMMDD HHMMSS format
TIMESTAMP=$(date +"%Y%m%d %H%M%S")
TIMESTAMP_FORMATTED=$(date +"%d-%m-%y %H:%M:%S")

# Create secure temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Create the text content locally
cat > "$TEMP_DIR/Victron_data.txt" << EOF
$TIMESTAMP
Solar Today $SOLAR
Import Today $IMPORT
Load Today $LOAD
Battery $BATTERY%
Solar Now $SOLAR_NOW
Import Now $IMPORT_NOW
Load Now $LOAD_NOW
Battery Charge $BATTERY_CHARGE
Battery Discharge $BATTERY_DISCHARGE
Cell Diff $CELL_DIFF
Immersion Upper $IMMERSION_UPPER
Immersion Lower $IMMERSION_LOWER
Battery Voltage $BATTERY_VOLTAGE
DVCC Max Current $DVCC_MAX_CURRENT
EOF

# Create the JSON content locally
cat > "$TEMP_DIR/Victron_data.json" << EOF
{
  "timestamp": "$TIMESTAMP",
  "timestamp_formatted": "$TIMESTAMP_FORMATTED",
  "solar_today": $SOLAR,
  "import_today": $IMPORT,
  "load_today": $LOAD,
  "battery_percent": $BATTERY,
  "solar_now": $SOLAR_NOW,
  "import_now": $IMPORT_NOW,
  "load_now": $LOAD_NOW,
  "battery_charge": $BATTERY_CHARGE,
  "battery_discharge": $BATTERY_DISCHARGE,
  "cell_diff": $CELL_DIFF,
  "immersion_upper": $IMMERSION_UPPER,
  "immersion_lower": $IMMERSION_LOWER,
  "battery_voltage": $BATTERY_VOLTAGE,
  "dvcc_max_current": $DVCC_MAX_CURRENT
}
EOF

# Upload text file to PythonAnywhere with error handling
if ! curl_response=$(curl -s -w "%{http_code}" -X POST \
  -H "Authorization: Token $PA_TOKEN" \
  -F "content=@$TEMP_DIR/Victron_data.txt" \
  "https://www.pythonanywhere.com/api/v0/user/$PA_USERNAME/files/path$PA_PATH/Victron_data.txt" 2>&1); then
    echo "Error: Failed to upload text file: $curl_response" >&2
    exit 1
fi

# Upload JSON file to PythonAnywhere with error handling
if ! curl_response=$(curl -s -w "%{http_code}" -X POST \
  -H "Authorization: Token $PA_TOKEN" \
  -F "content=@$TEMP_DIR/Victron_data.json" \
  "https://www.pythonanywhere.com/api/v0/user/$PA_USERNAME/files/path$PA_PATH/Victron_data.json" 2>&1); then
    echo "Error: Failed to upload JSON file: $curl_response" >&2
    exit 1
fi

# Log the operation (to a safer location)
LOG_FILE="${LOG_FILE:-/tmp/upload_log.txt}"
echo "$(date): Victron data uploaded to PythonAnywhere successfully" >> "$LOG_FILE"