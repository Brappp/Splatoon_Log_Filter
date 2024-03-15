Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$initialDirectory = "C:\Users\$env:USERNAME\AppData\Roaming\XIVLauncher\pluginConfigs\Splatoon\Logs"

$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = $initialDirectory
$dialog.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*"
$dialog.Title = "Select a Log File"

$result = $dialog.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $originalLogFilePath = $dialog.FileName
} else {
    Write-Host "No file selected. Exiting script."
    exit
}

$characterName = "YourCharacterName"

$jobsToExclude = @("Paladin", "Warrior", "Dark Knight", "Gunbreaker", "White Mage", "Scholar", "Astrologian", "Sage", "Monk", "Dragoon", "Ninja", "Samurai", "Reaper", "Bard", "Machinist", "Dancer", "Black Mage", "Summoner", "Red Mage", "Blue Mage")

$lines = Get-Content $originalLogFilePath

$extractedLines = @()

foreach ($line in $lines) {
    if ($line -match "readies|starts casting|uses" -and $line -notmatch $characterName) {
        $containsJob = $false
        foreach ($job in $jobsToExclude) {
            if ($line -match $job) {
                $containsJob = $true
                break
            }
        }
        if (-not $containsJob) {
            $extractedLines += $line
        }
    }
}

$extractedLinesCount = $extractedLines.Count

$filenameWithoutExtension = [System.IO.Path]::GetFileNameWithoutExtension($originalLogFilePath)
$directory = [System.IO.Path]::GetDirectoryName($originalLogFilePath)
$extension = [System.IO.Path]::GetExtension($originalLogFilePath)
$filteredLogFilePath = "$directory\$filenameWithoutExtension`_filtered$extension"

$extractedLines | Set-Content $filteredLogFilePath

Write-Host "Number of extracted lines $extractedLinesCount"