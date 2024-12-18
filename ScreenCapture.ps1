<#
Title:         ScreenCapture Powershell
Author: 	   Mikeelio (Robin Sharma)
Date Created:  October 31, 2023  	     
Description:   This program takes a screenshot every 1 Hour from the time inputted by the user. The screenshots are saved to a location set by the user. The Program is set to run till 2am unless it is changed.

NOTE: 		 If it breaks, dont touch it cause yall gonna mess it up more than I can fix it
 #>


#variable declare
$data = New-Object System.Collections.ArrayList(8)
$last_screenshot = "No Screenshot Taken Yet"
$current_time=""
$h=0 #For Time Array Setup
$i=0



# Location Paths
$user=$Env:UserName
$current_date=GET-DATE -Format 'MM-dd-yy'
$screenshot_path = "C:\Users\${user}\Desktop\Screenshots\${current_date}"

[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[Environment]::UserName
Clear-Host

#Asks User for the Start Time. It then checks if the user has entered the time correctly based on thr format.
$Starttime = Read-Host -Prompt 'Input Start time (ex. 17:10)'
while($Starttime.length -ne 5 -or $Starttime.length -gt 5){
	Clear-Host
	$Starttime = Read-Host -Prompt "You put in (${Starttime}). Please Input Correct Start time (ex. 17:10)"
}
Clear-Host


#Start time is split into Hour/Min and then creates an array where the hour is increased by 1 hour. It also checks if the minutes is less than 10 which then adds a 0 to the front (ex. 01:03 instead of 01:3)
$split_time =$Starttime.Split(":")
$hour_int = [int]$split_time[0]
$min = [int]$split_time[1]

while($h -ne 8){
	$hour_int++
	$hour = $hour_int
	if ($hour_int -eq 24){
		$hour_int=0
	}
	if ($hour_int -lt 10){
		$hour="0${hour_int}"
	}

	#Checks if the minutes are less than 9.
	if ($min -le 9 ){
		$data.Add("${hour}:0${min}") 
	}
	else{
		$data.Add("${hour}:${min}" ) 
	}
	$h++
}

#Checks if the current time is in the array.If yes then it will take a screenshot of whatever is on the screen. Note: Need to add where it focuses on a certain window.
while ($i -ne 8){
	foreach ($item in $data) {
		$current_time= GET-DATE -Format 'HH:mm'
		Clear-Host
		Write-Host "Last Screenshot taken at: ${last_screenshot}"
		Write-Host "Current Time is: ${current_time}"
		Write-Host "Checking if the time is: $item"

		#Check if the current time is equal to $item which is taking information from $data.
		if ($current_time -eq $item){
			Write-Host "Taking Screenshot at ${current_time}"
			$last_screenshot = "${current_time}"
			function screenshot([Drawing.Rectangle]$bounds, $path) {
				$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
				$graphics = [Drawing.Graphics]::FromImage($bmp)

				$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

				$bmp.Save($path)

				$graphics.Dispose()
				$bmp.Dispose()
			}

			$bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1920, 1080)
			
			$current_time=GET-DATE -Format 'HH:mm'
			if (Test-Path -Path $screenshot_path) {
				Write-Host "Screenshot successful."
			} else {
				mk $screenshot_path
				Write-Host "Folder does not exist. Folder was created on desktop"
			}
			
			Start-Sleep -Seconds 3
			$screenshot_time = GET-DATE -Format 'HH_mm'
			screenshot $bounds "${screenshot_path}\screenshot_${screenshot_time}.png"
			Write-Host "Entering Sleep for 2 min and 30 Seconds"
			Start-Sleep -Seconds 150
			Clear-Host
		}
		if ($current_time -eq "04:00"){
			exit
		}	
	   Start-Sleep -Seconds 3
	   Clear-Host
	   $i++
	}
}

