# Now Playing OBS
Application for embedding currently playing song in OBS (or any other streaming software that supports window capture and chroma key)

This app is still WIP and has no customization whatsoever, also it cant run in background, so the window should always be in foreground, if you minimize the window Flutter will stop rendering it

## How to use
1. Download latest Release.7z from Releases section
2. Unpack it
3. Launch nowplaying_obs.exe
4. Maximize the window
5. Setup window capture and chroma key (i recommend you to use Similarity: 325 for best results)
6. Align the window capture to the bottom
7. Install a plugin for your browser

## How to make your own plugins
All you need to do is send POST request to `http://127.0.0.1:50142` with JSON data

### JSON fields
`artist`: Artist name  
`name`: Song name

## Firefox plugin (currently the only way to use this app)
https://github.com/notmyst33d/nowplaying_obs_firefox_plugin
