#Created by mikeelio
#If it breaks, dont touch it cause yall gonna mess it up more than I can fix it
[Reflection.Assembly]::LoadWithPartialName("System.Drawing")
[Environment]::UserName


#Array Declare
$sunday_schedule=New-Object System.Collections.ArrayList(8)
$mon_fri_schedule=New-Object System.Collections.ArrayList(8)


#variable stuff
$user=$Env:UserName

$data = New-Object System.Collections.ArrayList(8)


<#
The variables listed below can be changed to the users preference. The default info below are the ones that can be changed at the moment. More to come later on.

#>
$save_to_location = "C:\Users\${user}\Desktop\Screenshots\${current_date}\screenshot_${l}.png"
$screenshot_path = "C:\Users\${user}\Desktop\Screenshots\${current_date}"
$sunday_schedule = "15:10","16:10","17:10","18:10","19:10","20:10","21:10"
$mon_fri_schedule = "16:10","17:10","18:10","19:10","20:10","21:10","22:10"


#functions
function clear_screen(){
	Clear-Host
}

function screenshot([Drawing.Rectangle]$bounds, $path) {
				
	$bmp = New-Object Drawing.Bitmap $bounds.width, $bounds.height
	$graphics = [Drawing.Graphics]::FromImage($bmp)

	$graphics.CopyFromScreen($bounds.Location, [Drawing.Point]::Empty, $bounds.size)

	$bmp.Save($path)

	$graphics.Dispose()
	$bmp.Dispose()
}

function automatic_sort($sun, $mon_fri){
	$day = Get-Date -Format "dddd"
	
	if ($day -eq "Sunday"){
		Write-host "Running in Sunday Sort Schedule"
		Write-host "Current Times for screenshots are ${sunday_schedule}"
		Write-host "Starting up ScreenCapture sequence. Please keep the window set to Overview at all times to capture the numbers"
		Start-Sleep -Seconds 2
		clear_screen
		main_loop $sunday_schedule
	}
	elseif ($day -eq "Saturday"){
		Write-host "Switching to Manual Mode due to saturday sort not being a constant scheduled shift. Please stand by!!"
		Start-Sleep -Seconds 2
		clear_screen
		manual_sort
	}
	else{
		Write-host "Running in Monday - Friday Sort Schedule"
		Write-host "Current Times for screenshots are ${mon_fri_schedule}"
		Write-host "Starting up ScreenCapture sequence. Please keep the window set to Overview at all times to capture the numbers"
		Start-Sleep -Seconds 2
		clear_screen
		main_loop $mon_fri_schedule
	}
	
	
}
function manual_sort(){
	$Starttime = Read-Host -Prompt 'Input Start time'
	$split_time =$Starttime.Split(":")
	$hour = [int]$split_time[0]
	$min = [int]$split_time[1]
	$i=0

	while($i -ne 8){
		$hour++
		if ($hour -eq 24){
			$hour=00
		}
		$data.Add("${hour}:${min}" ) 
		$i++
	}
	Write-host "Starting up ScreenCapture sequence. Please keep the window set to Overview at all times to capture the numbers"
	Start-Sleep -Seconds 2
	clear_screen
	main_loop $data
}

function main_loop($data){
	
	$current_date=GET-DATE -Format 'MM-dd-yy'

	$i=0
	$l=0
	$m=0

	while ($l -ne 8){
		foreach ($item in $data) {
			$current_time=""
			$current_time=GET-DATE -Format 'HH:mm'
			Write-Host "Current Time is: ${current_time}"
			Write-Host "Checking if the time is $item"
			if ($current_time -eq $item){
				Write-Host "Taking Screenshot at ${current_time}"
				$bounds = [Drawing.Rectangle]::FromLTRB(0, 0, 1920, 1080)			
				$current_time=GET-DATE -Format 'HH:mm'
				if (Test-Path -Path $screenshot_path) {
					Write-Host""
				} else {
					md $screenshot_path
				}		
				Start-Sleep -Seconds 3
				screenshot $bounds $save_to_location
				Write-Host "Entering Sleep for 2 min and 30 Seconds"
				Start-Sleep -Seconds 150
				clear_screen
				$l++
			}
			if ($current_time -eq "01:00" -OR $current_time -eq "1:00"){
				exit
			}			
		   Start-Sleep -Seconds 3
		   $i++
		}
	} 	
}


Write-Host "---------------------------------"
Write-Host "ScreenCapture.ps1"
Write-Host "Created by Robin Sharma (4018645)"
Write-Host "---------------------------------"
Write-Host "Please Choose the following: 1. Automatic Sort (Sunday to Friday) | 2. Manual Sort"
$user_selection=Read-Host -Prompt " "

if ($user_selection -eq 1) {
	automatic_sort 
}
elseif ($user_selection -eq 2){
	manual_sort
}








