$jobs = @(
    "Paladin",
    "Warrior",
    "DarkKnight",
    "Gunbreaker",
    "WhiteMage",
    "Scholar",
    "Astrologian",
    "Sage",
    "Monk",
    "Dragoon",
    "Ninja",
    "Samurai",
    "Reaper",
    "Bard",
    "Machinist",
    "Dancer",
    "BlackMage",
    "Summoner",
    "RedMage",
    "BlueMage"
)

$allData = @()

foreach ($job in $jobs) {
    try {

        $url = "https://na.finalfantasyxiv.com/jobguide/$($job.ToLower())/"
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing
        $pattern = '<strong>(.*?)</strong>'
        $matched = [regex]::Matches($response.Content, $pattern)

        foreach ($match in $matched) {
            $content = $match.Groups[1].Value
            $allData += $content
        }
    } catch {
        Write-Warning "Failed to process $job - $_"
    }
}

$distinctData = $allData | Select-Object -Unique

$distinctData
