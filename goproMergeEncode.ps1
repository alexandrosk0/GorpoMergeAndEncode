#Gopro Hero 4 file merge and Encode helper
#Merge and encode multiple mp4 files in the given gopro export folder
#Needs mkvmerge https://mkvtoolnix.download/ and HandBrake https://handbrake.fr/downloads2.php
#Example usage .\goproMergeEncode1440p60.ps1 -dir "d:\Video\GoPro\2019-04-21\HERO5 Black 1\" -preset "Vimeo YouTube HQ 1440p60 2.5K"
#Add extra parameters to using MKVMergeExtraParam and HandbrakeExtraParam
#Use -test to encode three seconds of each video
#Based on the file name format GOPR2548.MP4, GP012548.MP4 and folder format ..\GoPro\2019-04-21\HERO5 Black 1\

param (
    [string]$dir = $(Get-Location),
	[string]$preset = 'Vimeo YouTube HQ 1440p60 2.5K',
	[string]$MKVMergeExtraParam = '',
	[string]$HandbrakeExtraParam = '',
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
		"`n`n`n`n`n`n`n`n`n`n`n`n"
		$root = $initFile.name.Substring(4).Split(".")[0]
		$filesCount = (Get-ChildItem -Filter G*$root*.mp4 -Path $dir).Count
		$filesFullname = (Get-ChildItem -Filter G*$root*.mp4 -Path $dir).fullname


		'Processing ' + $filesCount + " files:`n" + $filesFullname + "`n`n"		

		$outputMerged = $dir.ToString() + 'Temp'  + $initFile.BaseName + '-' + $date + '.mkv'

		$outputEncoded = $dir.ToString() + 'Encoded-'  + $initFile.BaseName + '-' + $date + '.mp4'

		$start = '"C:/Program Files/MKVToolNix\mkvmerge.exe" --ui-language en --output ^"' + $outputMerged + '^" --language 0:und --language 1:und ^"^(^" ^"'
		$cmdMerge = $start + ($filesFullname -join '^" ^"^)^" + ^"^(^" ^"') + '^" ^"^)^" --track-order 0:0,0:1 ' + $MKVMergeExtraParam

		cmd /c $cmdMerge
		$cmdEncode = '"C:\Program Files\HandBrake\HandBrakeCLI.exe" --preset "' + $preset + '" -i"' + $outputMerged + '" -o "' + $outputEncoded + '" --turbo ' + $HandbrakeExtraParam

		cmd /c $cmdEncode 

		if ($LASTEXITCODE -ne 0) 
		{
			$error.Clear()
			"`nAn error occurred, aborting deletion of files:`n" + $filesFullname
		}
		else
		{
			Remove-Item $outputMerged
			if (-Not $test)
			{
				Remove-Item $filesFullname
			}
			"`n`nFinished successfully at " + $(get-date) + " processing files:`n " + $filesFullname
		}		
	}	
}
else
{
	"`nNo MP4 files to process if folder " + $dir
}