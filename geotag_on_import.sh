#!/bin/bash

# ========= CONFIGURATION =========
GPX_DIR="/mnt/gdrive/GPSLogger for Android" # folder where .gpx files are stored
TIMEZONE_OFFSET="+01:00"  # e.g. if camera is in BST and GPX is in UTC, use +01:00

EXIFTOOL="$(command -v exiftool)"

# ========= LOGGING (uncomment to enable - warning log file size will grow over time) =========
# exec >> /tmp/digikam-geotag.log 2>&1
# echo "========== $(date) =========="
# echo "Processing photo: $1"

PHOTO="$1"
[ ! -f "$PHOTO" ] && { echo "File not found: $PHOTO"; exit 1; }

# ========= CHECK FOR EXISTING GPS =========
GPS_PRESENT=$($EXIFTOOL -s3 -GPSLatitude "$PHOTO")
if [[ -n "$GPS_PRESENT" ]]; then
    echo "GPS data already present. Skipping."
    exit 0
fi

# ========= EXTRACT PHOTO DATE =========
PHOTO_DATE=$($EXIFTOOL -s3 -DateTimeOriginal "$PHOTO" | cut -d' ' -f1)  # e.g., 2025:06:29
if [[ -z "$PHOTO_DATE" ]]; then
    echo "No DateTimeOriginal found. Skipping."
    exit 1
fi

GPX_DATE=$(echo "$PHOTO_DATE" | tr -d ':')  # e.g., 20250629
GPX_FILE="${GPX_DIR}/${GPX_DATE}.gpx"

if [ ! -f "$GPX_FILE" ]; then
    echo "GPX file not found: $GPX_FILE. Skipping."
    exit 1
fi

echo "Using GPX file: $GPX_FILE"

# ========= GEO-TAGGING =========
echo "Geotagging $PHOTO using exiftool with offset $TIMEZONE_OFFSET..."
$EXIFTOOL -overwrite_original -geotag "$GPX_FILE" "-geosync=$TIMEZONE_OFFSET" "$PHOTO"

# ========= SHOW RESULT =========
$EXIFTOOL -GPSLatitude -GPSLongitude "$PHOTO"
