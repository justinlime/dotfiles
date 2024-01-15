#Hello world!!!!!!
$init_file = "Z:\output.mkv"
$ffmpeg = "C:\Users\justi\Documents\My Documents\Software\ffmpeg\ffmpeg.exe"
$uncompressed_dir = "Z:\Recordings\PC\Escape From Tarkov\Uncompressed Recordings"
$compressed_dir = "Z:\Recordings\PC\Escape From Tarkov\Compressed Recordings"

Write-Host "Using $($init_file)`n"
$file_name = Read-Host "Enter the name for the video "
$file_name = $file_name -replace '\.[^.]*$'

Write-Host "`nWriting Uncompressed File to: $($uncompressed_dir)\$($file_name).mkv"
Write-Host "Writing Compressed File to: $($compressed_dir)\$($file_name).mkv`n"
do {
  $choice = Read-Host "Do you wish to proceed? [y/n]"
} while ($choice -ne 'y' -and $choice -ne 'n')

if ($choice -eq "y") {
    Write-Host "Encoding"
} else {
    Exit
} 

Copy-Item -Path "$init_file" -Destination "$($uncompressed_dir)\$($file_name).mkv"

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
