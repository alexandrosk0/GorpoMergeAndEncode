#Gorpo file merger and encoding in Powershell using MKVToolNix and Handbrake
#Merge and encode single videos split in multiple mp4 files in the given gopro export folder and removes original files if succesfull.
#It can handle mulitple single videos in the same directory.
#Needs MKVmerge https://mkvtoolnix.download/ and HandBrakeCLI https://handbrake.fr/downloads2.php
#See official Handbrake presets https://handbrake.fr/docs/en/latest/technical/official-presets.html

#Parameters
#-dir Defaults to current directory
#-preset Default preset "Vimeo YouTube HQ 1440p60 2.5K"
#-MKVMergeExtraParam and -HandbrakeExtraParam Extra parameters for each program 
#-test Test merge and encode three seconds of each video, without deleting the original files
#-delete Delete original files if not error is returned. Defaults to true
#-mergeAll Ignore file naming and merge all files in the directory
#-noEncoding Skip encoding step

#Based on the file name format GOPR2548.MP4 and multiple files GP012548.MP4, GP022548.MP4,... and folder structure ..\GoPro\2019-04-21\HERO5 Black 1\
#Note that the stucture works for single videos for the camera models: HD HERO2, HERO3, HERO3+, HERO (2014), HERO Session, HERO4, HERO5 Black, HERO5 Session, HERO (2018)
#For HERO6 Black, & HERO7 (White, Silver, Black) or other formats use -mergeAll parameter
#See GoPro Camera File Naming Convention https://gopro.com/help/articles/question_answer/GoPro-Camera-File-Naming-Convention

#Example .\goproMergeEncode1440p60.ps1 -dir "D:\Video\GoPro\2019-04-21\HERO5 Black 1\" -preset "Vimeo YouTube HQ 1440p60 2.5K"
#Output file for D:\Video\GoPro\2019-04-21\HERO5 Black 1\GOPR2548.MP4 is Encoded-GOPR2548-20190421.mp4

param (
    [string]$dir = $(Get-Location),
	[string]$preset = 'Vimeo YouTube HQ 1440p60 2.5K',
	[string]$MKVMergeExtraParam = '',
	[string]$HandbrakeExtraParam = '',
	[switch]$delete = $true,
	[switch]$test = $false,
	[switch]$noEncoding = $false,
	[switch]$mergeAll = $false
)
"noEncoding $noEncoding"
"mergeAll $mergeAll"

if ($test)
{
	"Testing merging and encoding the first second. No original files will be removed"
	$HandbrakeExtraParam = $HandbrakeExtraParam + ' --start-at duration:0 --stop-at duration:3'
}

'Processing directory ' + $dir

if ($mergeAll)
{
	$rootFiles = (Get-ChildItem -Filter *.mp4 -Path $dir)
}
else
{
	$rootFiles = (Get-ChildItem -Filter GOPR*.mp4 -Path $dir)
	$date = $dir.Split("\")
	$date = $date[$date.length - 3].Replace("-", "")
}


if ($rootFiles.length -gt 0)
{
	ForEach ($initFile In $rootFiles)
	{
		if ($mergeAll)
		{
			$filesCount = $rootFiles.Count
			$filesFullname = $rootFiles.fullname
			$date = $initFile.LastWriteTime.ToString("yyyyMMdd")
		}
		else
		{
			$root = $initFile.name.Substring(4).Split(".")[0]
			$files = (Get-ChildItem -Filter G*$root*.mp4 -Path $dir)
			$filesCount = $files.Count
			$filesFullname = $files.fullname
		}

		'Processing ' + $filesCount + " files:`n" + $filesFullname + "`n`n"	

		$outputMerged = $dir.ToString() + 'Merged-'  + $initFile.BaseName + '-' + $date + '.mkv'

		$outputEncoded = $dir.ToString() + 'Encoded-'  + $initFile.BaseName + '-' + $date + '.mp4'

		$start = '"C:/Program Files/MKVToolNix\mkvmerge.exe" --ui-language en --output ^"' + $outputMerged + '^" --language 0:und --language 1:und ^"^(^" ^"'
		$cmdMerge = $start + ($filesFullname -join '^" ^"^)^" + ^"^(^" ^"') + '^" ^"^)^" --track-order 0:0,0:1 ' + $MKVMergeExtraParam

		cmd /c $cmdMerge

		$cmdEncode = '"C:\Program Files\HandBrake\HandBrakeCLI.exe" --preset "' + $preset + '" -i"' + $outputMerged + '" -o "' + $outputEncoded + '" --turbo ' + $HandbrakeExtraParam
		if (-Not $noEncoding)
		{
			cmd /c $cmdEncode 
		}

		if ($LASTEXITCODE -ne 0) 
		{
			$error.Clear()
			"An error occurred, aborting deletion of files:`n" + $filesFullname
		}
		else
		{
			if (-Not $noEncoding)
			{
				Remove-Item $outputMerged
			}
			
			if (-Not $test -And $delete)
			{
				"Removing files " + $filesFullname
				Remove-Item $filesFullname
			}
			"Finished successfully merging and encoding at " + $(get-date) + " processing files:`n " + $filesFullname
		}
		if ($mergeAll)
		{
			#Don't loop, all is merged
			exit
		}
	}	
}
else
{
	"No mp4 files to process in directory " + $dir
}
