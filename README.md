# Splatoon_Log_Filter
 
This PowerShell script filters out specific lines from a Splatoon log file you select. It's designed to extract lines containing certain keywords ```("readies", "starts casting", "uses")``` or any mentions of a list of job titles and a particular character name you specify. After filtering, it saves the results in a new file, using the original file's name with _filtered added before the file extension.

How It Works:

Select Your Log File: When you run the script, a file dialog will pop up, allowing you to choose the log file you want to filter.<br>
This will open the default path:<br> ```"C:\Users\$env:USERNAME\AppData\Roaming\XIVLauncher\pluginConfigs\Splatoon\Logs"```

Filtered File Creation: The script generates a new file in the same location as the original log file. This new file will have the same name as the original but with _filtered appended to it. For example, if your original file is named gameLog.txt, the filtered file will be gameLog_filtered.txt.

Important Notes:

Character Name Placeholder: Before running the script, locate the line ```$characterName = "YourCharacterName"``` and replace "YourCharacterName" with the actual name of the character you want to exclude from the log file. This ensures that any line mentioning this character will not appear in the filtered output.