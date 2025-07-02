# 📷 Automatic Photo Geotagging with DigiKam and GPSLogger

This project provides a shell script for [DigiKam](https://www.digikam.org/) to **automatically add GPS location data to photos during import**, using `.gpx` track logs recorded on your phone with [GPSLogger for Android](https://github.com/mendhak/gpslogger). You can edit geolocation and correlate with a gpx file in digikam without this script, 

The script matches each photo's timestamp with a GPX file named after the date the photo was taken (e.g. `20250702.gpx`) and uses `exiftool` to geotag the image in-place.

---

## ✅ Features

- Per-photo geotagging via DigiKam import script  
- Uses standard `.gpx` files from GPSLogger  
- Intended for photos lacking GPS metadata  

---

## 🛠 Requirements

- Linux, maybe macos (untested)
- [`exiftool`](https://exiftool.org/) - essential commandline tool for processing image metadata, handles all the gps correlation
- DigiKam (set to run this script on import)  
- GPX track files named as `YYYYMMDD.gpx`  
- Optional: [GPSLogger](https://github.com/mendhak/gpslogger) on your Android phone to create the gpx files
- Optional: Automate or Tasker app to start/stop GPSLogger

---

## 📁 Folder Structure

```
/mnt/gdrive/GPSLogger for Android/
  ├── 20250701.gpx
  ├── 20250702.gpx
  └── ...
```

Your `.gpx` files must be stored in a known directory, one per day, using the `YYYYMMDD.gpx` naming convention. This can be automated with the GPSLogger app.

---

## 📸 DigiKam Setup

1. Save the script below as `geotag_on_import.sh` (e.g. in `~/Code/`)  
2. Make it executable:

    ```bash
    chmod +x ~/Code/geotag_on_import.sh
    ```

3. In DigiKam, in the import window's scripting tab, add:
      ```
      /home/YOUR_USERNAME/Code/geotag_on_import.sh %file
      ```

---

## 📱 GPSLogger Android Setup (Auto Upload to Google Drive)

> This method assumes you use Google Drive, but you could adapt to Dropbox, Nextcloud, or Syncthing.

### Step-by-Step:

1. **Install GPSLogger** from [F-Droid](https://f-droid.org/packages/com.mendhak.gpslogger/)

2. **Configure Logging Format:**
   - Open **Settings** → **Logging Details**
   - Set **File Output Format** to `.gpx`
   - Enable **One file per day**
   - Enable **Add time zone to GPX**

3. **Enable Auto Upload:**
   - Go to **Settings** → **Auto send, email and upload**
   - Enable `Allow auto sending`
   - Choose **Google Drive** (other services should work fine too)
   - Grant access to your account
   - Choose your destination folder (e.g. `GPSLogger for Android`)

4. **Start Logging:**
   - Tap the red start button in GPSLogger to begin recording
   - It will automatically create a file named `YYYYMMDD.gpx` and upload it every 60 mins/daily/when you press stop depending on your settings.
     - I use Llamalab's Automate android app to start/stop tracking whenever I disconnect/reconnect from my wifi. This means whenever I get home, tracking is stopped and the gpx file immediately uploaded. Flow shared here: https://llamalab.com/automate/community/flows/51100

5. **Sync to your computer:**
   - Use Google Drive client, `rclone`, or another sync method to mirror the folder locally (e.g. to `/mnt/gdrive/GPSLogger for Android/`)

---

## 📜 License

MIT – use freely, modify, and share.
