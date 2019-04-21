#Gorpo file merger and encoding in Powershell using MKVToolNix and Handbrake
#Merge and encode multiple mp4 files in the given gopro export folder and deletes original files.
#Needs MKVmerge https://mkvtoolnix.download/ and HandBrakeCLI https://handbrake.fr/downloads2.php
#See official Handbrake presets https://handbrake.fr/docs/en/latest/technical/official-presets.html

#Parameters
#-dir Defaults to current directory
#-preset Default preset "Vimeo YouTube HQ 1440p60 2.5K"
#-MKVMergeExtraParam and -HandbrakeExtraParam Extra parameters for each program 
#-test Test merge and encode three seconds of each video, without deleting the original files
#-delete Delete original files if not error is returned. Defaults to true

#Based on the file name format GOPR2548.MP4 and multiple files GP012548.MP4, GP022548.MP4,... and folder structure ..\GoPro\2019-04-21\HERO5 Black 1\
#Note that the stucture works for single videos for the camera models: HD HERO2, HERO3, HERO3+, HERO (2014), HERO Session, HERO4, HERO5 Black, HERO5 Session, HERO (2018)
#See GoPro Camera File Naming Convention https://gopro.com/help/articles/question_answer/GoPro-Camera-File-Naming-Convention

#Example .\goproMergeEncode1440p60.ps1 -dir "D:\Video\GoPro\2019-04-21\HERO5 Black 1\" -preset "Vimeo YouTube HQ 1440p60 2.5K"
#Output file for D:\Video\GoPro\2019-04-21\HERO5 Black 1\GOPR2548.MP4 is Encoded-GOPR2548-20190421.mp4

param (
    [string]$dir = $(Get-Location),
	[string]$preset = 'Vimeo YouTube HQ 1440p60 2.5K',
	[string]$MKVMergeExtraParam = '',
	[string]$HandbrakeExtraParam = '',
	[switch]$delete = $true,
	[switch]$test = $false
)

if ($test)
{
	"Testing merging and encoding the first second. Not removing the original files"
	$HandbrakeExtraParam = $HandbrakeExtraParam + ' --start-at duration:0 --stop-at duration:3'
}

'Processing folder ' + $dir
$date = $dir.Split("\")
$date = $date[$date.length - 3].Replace("-", "")
$rootFiles = (Get-ChildItem -Filter GOPR*.mp4 -Path $dir)

if ($rootFiles.length -gt 0)
{
	ForEach ($initFile In $rootFiles)
	{
		$root = $initFile.name.Substring(4).Split(".")[0]
		$filesCount = (Get-ChildItem -Filter G*$root*.mp4 -Path $dir).Count
		$filesFullname = (Get-ChildItem -Filter G*$root*.mp4 -Path $dir).fullname


		'Processing ' + $filesCount + " files:`n" + $filesFullname + "`n`n"		

		$outputMerged = $dir.ToString() + 'Temp-'  + $initFile.BaseName + '-' + $date + '.mkv'

		$outputEncoded = $dir.ToString() + 'Encoded-'  + $initFile.BaseName + '-' + $date + '.mp4'

		$start = '"C:/Program Files/MKVToolNix\mkvmerge.exe" --ui-language en --output ^"' + $outputMerged + '^" --language 0:und --language 1:und ^"^(^" ^"'
		$cmdMerge = $start + ($filesFullname -join '^" ^"^)^" + ^"^(^" ^"') + '^" ^"^)^" --track-order 0:0,0:1 ' + $MKVMergeExtraParam

		cmd /c $cmdMerge
		$cmdEncode = '"C:\Program Files\HandBrake\HandBrakeCLI.exe" --preset "' + $preset + '" -i"' + $outputMerged + '" -o "' + $outputEncoded + '" --turbo ' + $HandbrakeExtraParam

		cmd /c $cmdEncode 

		if ($LASTEXITCODE -ne 0) 
		{
			$error.Clear()
			"An error occurred, aborting deletion of files:`n" + $filesFullname
		}
		else
		{
			Remove-Item $outputMerged
			if (-Not $test -And $delete)
			{
				Remove-Item $filesFullname
			}
			"Finished successfully at " + $(get-date) + " processing files:`n " + $filesFullname
		}		
	}	
}
else
{
	"No mp4 files to process in folder " + $dir
}
