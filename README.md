# GorpoUtil
Gorpo file merger and encoding in Powershell using \MKVToolNix and Handbrake


Merge and encode multiple mp4 files in the given gopro export folder
Needs MKVmerge https://mkvtoolnix.download/ and HandBrakeCLI https://handbrake.fr/downloads2.php
Example usage .\goproMergeEncode1440p60.ps1 -dir "d:\Video\GoPro\2019-04-21\HERO5 Black 1\" -preset "Vimeo YouTube HQ 1440p60 2.5K"
More official Handbrake presets here: https://handbrake.fr/docs/en/latest/technical/official-presets.html

Add extra parameters to using MKVMergeExtraParam and HandbrakeExtraParam
Use -test to encode three seconds of each video

Based on the file name format GOPR2548.MP4 and multiple files GP012548.MP4, GP022548.MP4,... and folder format ..\GoPro\2019-04-21\HERO5 Black 1\
