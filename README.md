# GorpoUtil
Gorpo file merger and encoding in Powershell using **MKVToolNix and Handbrake**


Merge and encode multiple mp4 files in the given gopro export folder and deletes original files.
Needs [MKVmerge](https://mkvtoolnix.download/) and [HandBrakeCLI](https://handbrake.fr/downloads2.php)

See [official Handbrake presets](https://handbrake.fr/docs/en/latest/technical/official-presets.html)

Parameters

**-dir** Defaults to current directory

**-preset** Default preset "Vimeo YouTube HQ 1440p60 2.5K"

**-MKVMergeExtraParam** and **-HandbrakeExtraParam** Extra parameters for each program 

**-test** Test merge and encode three seconds of each video, without deleting the original files

**-delete** Delete original files if not error is returned. Defaults to true

Output file is Encoded-{original filename}-{date of subfolder}

Example
**.\goproMergeEncode1440p60.ps1 -dir "d:\Video\GoPro\2019-04-21\HERO5 Black 1\" -preset "Vimeo YouTube HQ 1440p60 2.5K"**
Output file for D:\Video\GoPro\2019-04-21\HERO5 Black 1\GOPR2548.MP4 is Encoded-GOPR2548-20190421.mp4

Based on the file name format GOPR2548.MP4 and multiple files GP012548.MP4, GP022548.MP4,... and folder structure ..\GoPro\2019-04-21\HERO5 Black 1\
Note that the stucture works for single videos for the camera models: HD HERO2, HERO3, HERO3+, HERO (2014), HERO Session, HERO4, HERO5 Black, HERO5 Session, HERO (2018)
See [GoPro Camera File Naming Convention](https://gopro.com/help/articles/question_answer/GoPro-Camera-File-Naming-Convention)

