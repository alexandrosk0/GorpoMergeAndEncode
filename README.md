# GorpoMergeAndEncode
Merge and encode single videos split into multiple mp4 files with PowerShell using **MKVToolNix and Handbrake**

## Description
Merge and encode single videos split into multiple mp4 files in the given GoPro export folder and removes original files if successful. various unique recording in the same directory.

Requires [MKVmerge](https://mkvtoolnix.download/) and [HandBrakeCLI](https://handbrake.fr/downloads2.php) installed in C:/Program Files/MKVToolNix\ and C:\Program Files\HandBrake\ respectively.


See [official Handbrake presets](https://handbrake.fr/docs/en/latest/technical/official-presets.html)

Output file is Encoded-{original filename}-{date of subfolder}

## Parameters

* `-dir` Defaults to the current directory
* `-preset` The default preset is "Vimeo YouTube HQ 1440p60 2.5K".
* `-MKVMergeExtraParam` Extra parameters for MKVMerge
* `-HandbrakeExtraParam` Extra parameters for Handbrake
* `-test` Test merge and encode three seconds of each video, without deleting the original files
* `-delete` Delete original files if no error is found. Defaults to true
* `-mergeAll` Ignore file naming and merge all files in the directory
* `-noEncoding` Skip encoding step, only merge


## Example
`.\goproMergeEncode.ps1 -dir "d:\Video\GoPro\2019-04-21\HERO5 Black 1\"`

To run from command line:
`powershell.exe –ExecutionPolicy Bypass -noexit "& 'D:\goproMergeEncode.ps1' -dir 'D:\Video\GoPro\2019-04-19\HERO5 Black 1\' -test"`

Output file for D:\Video\GoPro\2019-04-21\HERO5 Black 1\GOPR2548.MP4 is Encoded-GOPR2548-20190421.mp4

## Issues running PowerShell
By default, Windows doesn't allow to run PowerShell scripts, see [execution policies](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies?view=powershell-6#powershell-execution-policies)

### Permanent allow running this script
Open Start, search for PowerShell, right-click the top-result and click the Run as administrator option.

Check your execution policy by running the command `Get-ExecutionPolicy`

To change to a policy that allows you to run scripts, run PowerShell as administrator and run `Set-ExecutionPolicy RemoteSigned`

To unblock this file only, go to the folder you downloaded the file and run `Unblock-File .\goproMergeEncode.ps1`

### Temporary allow
Run from command line `powershell –ExecutionPolicy Bypass`

All scripts run during this session will bypass the restrictions.

## Notes
Based on the file name format GOPR2548.MP4 and multiple files GP012548.MP4, GP022548.MP4,... and folder structure ..\GoPro\2019-04-21\HERO5 Black 1\
Note that the script expects an arrangement that works for single videos for the camera models: HD HERO2, HERO3, HERO3+, HERO (2014), HERO Session, HERO4, HERO5 Black, HERO5 Session, HERO (2018)

For HERO6 Black, & HERO7 (White, Silver, Black) or other formats use -mergeAll parameter. See [GoPro Camera File Naming Convention](https://gopro.com/help/articles/question_answer/GoPro-Camera-File-Naming-Convention)

Note that HandBrake doesn't support merging.

## Alternatives
- If you don't like PowerShell, although it's OSS and available in all platforms now, for linux bash you can use https://github.com/KonradIT/gopro-linux which also have much more features.
- For tools with a user interface use https://www.mp4joiner.org/en/ or other tools from https://www.fosshub.com/Video-Editors.html


## About
This script was made quickly with the goal for me to learn more about PowerShell.
Probably would be better to use ffmpeg, but I like the presets of HandBrake, and my focus was mostly on learning to script something using PowerShell.

Decided to make it open source, since others might find useful, but now I have spent more time on documentation than actual scripting :)

## Contact
All code reviews, suggestions, recommendations, pieces of advice, optimizations, insults are welcomed.
alexkonstantonis@gmail.com
