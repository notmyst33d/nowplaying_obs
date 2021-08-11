# Now Playing OBS
Application for embedding currently playing song in OBS (or any other streaming software that supports window capture and chroma key)

State: Stable enough, but there could be some bugs.

## Installing
1. Download latest Release.7z from Releases section
2. Unpack it
3. Install a plugin for your browser

## Use cases
### OBS Browser element (recommended)
1. Launch start_as_server.bat
2. Add Browser element with https://notmyst33d.github.io/nowplaying_obs link and apply chroma key filter (i recommend you to use Similarity: 325 for best results)
3. Align the Browser element to the bottom

### Standalone
1. Launch nowplaying_obs.exe
2. Setup window capture and apply chroma key filter (i recommend you to use Similarity: 325 for best results)
3. Align the window capture to the bottom

Note: If you will minimize the window it will stop rendering it, so please keep it in foreground

## Opening settings menu
If you are using this app standalone then it should be pretty straightforward, hover on top left corner and settings button should appear.

If you are using OBS Browser element you can do this:  
<img src="https://raw.githubusercontent.com/notmyst33d/nowplaying_obs/assets/obs_settings.gif" width="500">

...or, if you have hard time finding the top left corner, disable chroma key:  
<img src="https://raw.githubusercontent.com/notmyst33d/nowplaying_obs/assets/obs_no_chroma_key_settings.gif" width="500">

## How to make your own plugins
All you need to do is send POST request to `http://127.0.0.1:50142` with JSON data

### JSON fields
`artist`: Artist name  
`name`: Song name

## Browser plugin
https://github.com/notmyst33d/nowplaying_obs_plugin
