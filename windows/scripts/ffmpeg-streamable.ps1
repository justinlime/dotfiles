# If powershell scripts aren't enabled yet, enter a terminal as admin and run:
# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned 


# The init file to compress and move
$init_file = "Z:\output.mkv"
# Path to FFMPEG
$ffmpeg = "C:\Users\justi\Documents\My Documents\Software\ffmpeg\ffmpeg.exe"

Write-Host "Using $($init_file)`n"
# Game Name
$game = Read-Host "Enter the name of the game (Required Exact Match)"
# Local directories to copy the files to
$uncompressed_dir = "Z:\Recordings\PC\$($game)\Uncompressed Recordings"
$compressed_dir = "Z:\Recordings\PC\$($game)\Compressed Recordings"
# Remote directories to copy the files to
$uncompressed_dir_remote = "\\192.168.4.59\storage\users\justin\Recordings\PC\$($game)\Uncompressed Recordings"
$compressed_dir_remote = "\\192.168.4.59\storage\users\justin\Recordings\PC\$($game)\Compressed Recordings"
# Confirmation
$file_name = Read-Host "Enter the name for the video (exclude the file extension)"
$file_name = $file_name -replace '\.[^.]*$'
Clear-Host
Write-Host "--Local Directories--"
Write-Host "Writing Uncompressed File to: `n$($uncompressed_dir)\$($file_name).mkv"
Write-Host "Writing Compressed File to: `n$($compressed_dir)\$($file_name).mkv"
Write-Host "`n--Remote Directories--"
Write-Host "Writing Uncompressed File to: `n$($uncompressed_dir_remote)\$($file_name).mkv"
Write-Host "Writing Compressed File to: `n$($compressed_dir_remote)\$($file_name).mkv"
do {
  $choice = Read-Host "`nDo you wish to proceed? [y/n]"
} while ($choice -ne 'y' -and $choice -ne 'n')

if ($choice -eq "y") {
    Write-Host "Encoding"
} else {
    Exit
} 
# Copy the uncompressed file to the remote and local dirs
Copy-Item -Path "$init_file" -Destination "$($uncompressed_dir)\$($file_name).mkv"
Copy-Item -Path "$init_file" -Destination "$($uncompressed_dir_remote)\$($file_name).mkv"
# Encode the file to the local dir and copy to the remote dir
& $ffmpeg -i "$init_file" `
       -c:v libsvtav1 `
       -vf "scale=1280x720" `
       -crf 20 `
       -preset 6 `
       -g 240 `
       -svtav1-params tune=0:enable-overlays=1:scd=1:scm=0 `
       -pix_fmt yuv420p10le `
       -c:a copy `
       "$($compressed_dir)\$($file_name).mkv"
Copy-Item -Path "$($compressed_dir)\$($file_name).mkv" -Destination "$($compressed_dir_remote)\$($file_name).mkv"
