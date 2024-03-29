Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$initialDirectory = "C:\Users\$env:USERNAME\AppData\Roaming\XIVLauncher\pluginConfigs\Splatoon\Logs"

$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.InitialDirectory = $initialDirectory
$dialog.Filter = "Text files (*.txt)|*.txt|All files (*.*)|*.*"
$dialog.Title = "Select a Log File"
$dialog.TopMost = $true

$result = $dialog.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    $originalLogFilePath = $dialog.FileName
} else {
    Write-Host "No file selected. Exiting script."
    exit
}

$characterName = "YourCharacterName" # UPDATE WITH YOUR CHARACTER NAME

$abilitiesToExclude = @(
    "Fast Blade", "Fight or Flight", "Riot Blade", "Total Eclipse", "Shield Bash", "Iron Will", "Release Iron Will",
    "Shield Lob", "Rage of Halone", "Spirits Within", "Sheltron", "Sentinel", "Prominence", "Cover",
    "Circle of Scorn", "Hallowed Ground", "Bulwark", "Goring Blade", "Divine Veil", "Clemency", "Royal Authority",
    "Intervention", "Holy Spirit", "Requiescat", "Passage of Arms", "Holy Circle", "Intervene", "Atonement",
    "Confiteor", "Holy Sheltron", "Expiacion", "Blade of Faith", "Blade of Truth", "Blade of Valor", "Rampart",
    "Low Blow", "Provoke", "Interject", "Reprisal", "Arm's Length", "Shirk", "Tank Mastery", "Oath Mastery",
    "Chivalry", "Rage of Halone Mastery", "Divine Magic Mastery", "Enhanced Prominence", "Enhanced Sheltron",
    "Sword Oath", "Enhanced Requiescat", "Sheltron Mastery", "Enhanced Intervention", "Divine Magic Mastery II",
    "Melee Mastery", "Spirits Within Mastery", "Enhanced Divine Veil", "Guardian", "Phalanx", "Standard-issue Elixir",
    "Recuperate", "Purify", "Guard", "Sprint", "Heavy Swing", "Maim", "Berserk", "Overpower", "Defiance", "Release Defiance",
    "Tomahawk", "Storm's Path", "Thrill of Battle", "Inner Beast", "Vengeance", "Mythril Tempest", "Holmgang", "Steel Cyclone",
    "Storm's Eye", "Infuriate", "Fell Cleave", "Raw Intuition", "Equilibrium", "Decimate", "Onslaught", "Upheaval", "Shake It Off",
    "Inner Release", "Chaotic Cyclone", "Nascent Flash", "Inner Chaos", "Bloodwhetting", "Orogeny", "Primal Rend", "The Beast Within",
    "Inner Beast Mastery", "Steel Cyclone Mastery", "Enhanced Infuriate", "Berserk Mastery", "Nascent Chaos", "Mastering the Beast",
    "Enhanced Shake It Off", "Enhanced Thrill of Battle", "Raw Intuition Mastery", "Enhanced Nascent Flash", "Enhanced Equilibrium",
    "Enhanced Onslaught", "Blota", "Primal Scream", "Hard Slash", "Syphon Strike", "Unleash", "Grit", "Release Grit", "Unmend",
    "Souleater", "Flood of Darkness", "Blood Weapon", "Shadow Wall", "Stalwart Soul", "Edge of Darkness", "Dark Mind", "Living Dead",
    "Salted Earth", "Plunge", "Abyssal Drain", "Carve and Spit", "Bloodspiller", "Quietus", "Delirium", "The Blackest Night",
    "Flood of Shadow", "Edge of Shadow", "Dark Missionary", "Living Shadow", "Oblation", "Salt and Darkness", "Shadowbringer", "Blackblood",
    "Enhanced Blackblood", "Darkside Mastery", "Enhanced Plunge", "Enhanced Unmend", "Enhanced Living Shadow", "Enhanced Living Shadow II",
    "Eventide", "Keen Edge", "No Mercy", "Brutal Shell", "Camouflage", "Demon Slice", "Royal Guard", "Release Royal Guard", "Lightning Shot",
    "Danger Zone", "Solid Barrel", "Burst Strike", "Nebula", "Demon Slaughter", "Aurora", "Superbolide", "Sonic Break", "Rough Divide",
    "Gnashing Fang", "Savage Claw", "Wicked Talon", "Bow Shock", "Heart of Light", "Heart of Stone", "Continuation", "Jugular Rip",
    "Abdomen Tear", "Eye Gouge", "Fated Circle", "Bloodfest", "Blasting Zone", "Heart of Corundum", "Hypervelocity", "Double Down",
    "Cartridge Charge", "Enhanced Brutal Shell", "Danger Zone Mastery", "Heart of Stone Mastery", "Enhanced Aurora", "Enhanced Continuation",
    "Cartridge Charge II", "Draw and Junction", "Junctioned Cast", "Relentless Rush", "Terminal Trigger", "Stone", "Cure", "Aero", "Medica",
    "Raise", "Stone II", "Cure II", "Presence of Mind", "Regen", "Cure III", "Holy", "Aero II", "Medica II", "Benediction", "Afflatus Solace",
    "Asylum", "Stone III", "Assize", "Thin Air", "Tetragrammaton", "Stone IV", "Divine Benison", "Plenary Indulgence", "Dia", "Glare",
    "Afflatus Misery", "Afflatus Rapture", "Temperance", "Glare III", "Holy III", "Aquaveil", "Liturgy of the Bell", "Repose", "Esuna",
    "Swiftcast", "Lucid Dreaming", "Surecast", "Rescue", "Stone Mastery", "Maim and Mend", "Freecure", "Maim and Mend II", "Aero Mastery",
    "Secret of the Lily", "Stone Mastery II", "Stone Mastery III", "Aero Mastery II", "Stone Mastery IV", "Transcendent Afflatus",
    "Enhanced Asylum", "Glare Mastery", "Holy Mastery", "Enhanced Healing Magic", "Enhanced Divine Benison", "Miracle of Nature",
    "Seraph Strike", "Afflatus Purgation", "Ruin", "Bio", "Physick", "Summon Eos", "Resurrection", "Whispering Dawn", "Bio II", "Adloquium",
    "Succor", "Ruin II", "Fey Illumination", "Aetherflow", "Energy Drain", "Lustrate", "Art of War", "Sacred Soil", "Indomitability",
    "Broil", "Deployment Tactics", "Emergency Tactics", "Dissipation", "Excogitation", "Broil II", "Chain Stratagem", "Aetherpact",
    "Dissolve Union", "Biolysis", "Broil III", "Recitation", "Fey Blessing", "Summon Seraph", "Consolation", "Broil IV", "Art of War II",
    "Protraction", "Expedient", "Embrace", "Fey Union", "Seraphic Veil", "Angel's Whisper", "Seraphic Illumination", "Away", "Heel",
    "Place", "Stay", "Steady", "Corruption Mastery", "Broil Mastery", "Broil Mastery II", "Corruption Mastery II", "Broil Mastery III",
    "Enhanced Sacred Soil", "Broil Mastery IV", "Art of War Mastery", "Enhanced Deployment Tactics", "Mummification", "Seraph Flight",
    "Malefic", "Benefic", "Combust", "Lightspeed", "Helios", "Ascend", "Essential Dignity", "Benefic II", "Draw", "Undraw", "Play",
    "Aspected Benefic", "Redraw", "Aspected Helios", "Gravity", "Combust II", "Synastry", "Divination", "Astrodyne", "Malefic II",
    "Collective Unconscious", "Celestial Opposition", "Earthly Star", "Stellar Detonation", "Malefic III", "Minor Arcana", "Combust III",
    "Malefic IV", "Celestial Intersection", "Horoscope", "Neutral Sect", "Fall Malefic", "Gravity II", "Exaltation", "Macrocosmos",
    "Microcosmos", "The Balance", "The Arrow", "The Spear", "The Bole", "The Ewer", "The Spire", "Lord of Crowns", "Lady of Crowns",
    "Enhanced Benefic", "Enhanced Draw", "Combust Mastery", "Enhanced Draw II", "Malefic Mastery", "Malefic Mastery II", "Hyper Lightspeed",
    "Combust Mastery II", "Malefic Mastery III", "Enhanced Essential Dignity", "Malefic Mastery IV", "Gravity Mastery", "Enhanced Celestial Intersection",
    "Double Cast", "Celestial River", "Dosis", "Diagnosis", "Kardia", "Prognosis", "Egeiro", "Physis", "Phlegma", "Eukrasia",
    "Eukrasian Diagnosis", "Eukrasian Prognosis", "Eukrasian Dosis", "Soteria", "Icarus", "Druochole", "Dyskrasia", "Kerachole", "Ixochole",
    "Zoe", "Pepsis", "Physis II", "Taurochole", "Toxikon", "Haima", "Dosis II", "Phlegma II", "Eukrasian Dosis II", "Rhizomata", "Holos",
    "Panhaima", "Dosis III", "Phlegma III", "Eukrasian Dosis III", "Dyskrasia II", "Toxikon II", "Krasis", "Pneuma", "Addersgall",
    "Somanoutic Oath", "Physis Mastery", "Somanoutic Oath II", "Addersting", "Offensive Magic Mastery", "Enhanced Kerachole",
    "Offensive Magic Mastery II", "Enhanced Zoe", "Mesotes", "Bootshine", "True Strike", "Snap Punch", "Meditation", "Steel Peak",
    "Twin Snakes", "Arm of the Destroyer", "Demolish", "Rockbreaker", "Thunderclap", "Howling Fist", "Mantra", "Four-point Fury",
    "Dragon Kick", "Perfect Balance", "Form Shift", "The Forbidden Chakra", "Masterful Blitz", "Elixir Field", "Flint Strike", "Celestial Revolution",
    "Tornado Kick", "Riddle of Earth", "Riddle of Fire", "Brotherhood", "Riddle of Wind", "Enlightenment", "Anatman", "Six-sided Star",
    "Shadow of the Destroyer", "Rising Phoenix", "Phantom Rush", "Second Wind", "Leg Sweep", "Bloodbath", "Feint", "True North",
    "Greased Lightning", "Enhanced Greased Lightning", "Deep Meditation", "Enhanced Greased Lightning II", "Steel Peak Mastery",
    "Enhanced Perfect Balance", "Deep Meditation II", "Howling Fist Mastery", "Enhanced Greased Lightning III", "Arm of the Destroyer Mastery",
    "Enhanced Thunderclap", "Flint Strike Mastery", "Enhanced Brotherhood", "Tornado Kick Mastery", "Earth's Reply", "Meteodrive", "True Thrust",
    "Vorpal Thrust", "Life Surge", "Piercing Talon", "Disembowel", "Full Thrust", "Lance Charge", "Jump", "Elusive Jump", "Doom Spike",
    "Spineshatter Dive", "Chaos Thrust", "Dragonfire Dive", "Battle Litany", "Fang and Claw", "Wheeling Thrust", "Geirskogul", "Sonic Thrust",
    "Dragon Sight", "Mirage Dive", "Nastrond", "Coerthan Torment", "High Jump", "Raiden Thrust", "Stardiver", "Draconian Fury", "Heavens' Thrust",
    "Chaotic Spring", "Wyrmwind Thrust", "Blood of the Dragon", "Lance Mastery", "Life of the Dragon", "Jump Mastery", "Lance Mastery II",
    "Life of the Dragon Mastery", "Enhanced Coerthan Torment", "Enhanced Spineshatter Dive", "Lance Mastery III", "Enhanced Life Surge",
    "Lance Mastery IV", "Horrid Roar", "Sky High", "Sky Shatter", "Spinning Edge", "Shade Shift", "Gust Slash", "Hide", "Throwing Dagger",
    "Mug", "Trick Attack", "Aeolian Edge", "Ten", "Ninjutsu", "Chi", "Death Blossom", "Assassinate", "Shukuchi", "Jin", "Kassatsu",
    "Hakke Mujinsatsu", "Armor Crush", "Dream Within a Dream", "Huraijin", "Hellfrog Medium", "Bhavacakra", "Ten Chi Jin", "Meisui",
    "Bunshin", "Phantom Kamaitachi", "Hollow Nozuchi", "Forked Raiju", "Fleeting Raiju", "Fuma Shuriken", "Katon", "Raiton", "Hyoton",
    "Huton", "Doton", "Suiton", "Goka Mekkyaku", "Hyosho Ranryu", "All Fours", "Fleet of Foot", "Adept Assassination", "Shukiho",
    "Enhanced Shukuchi", "Enhanced Mug", "Enhanced Shukuchi II", "Enhanced Kassatsu", "Shukiho II", "Shukiho III", "Melee Mastery II",
    "Enhanced Meisui", "Enhanced Raiton", "Three Mudra", "Seiton Tenchu", "Hakaze", "Jinpu", "Third Eye", "Enpi", "Shifu", "Fuga", "Gekko",
    "Iaijutsu", "Mangetsu", "Kasha", "Oka", "Yukikaze", "Meikyo Shisui", "Hissatsu: Shinten", "Hissatsu: Gyoten", "Hissatsu: Yaten",
    "Meditate", "Hissatsu: Kyuten", "Hagakure", "Ikishoten", "Hissatsu: Guren", "Hissatsu: Senei", "Tsubame-gaeshi", "Shoha", "Shoha II",
    "Fuko", "Ogi Namikiri", "Kaeshi: Namikiri", "Higanbana", "Tenka Goken", "Midare Setsugekka", "Kaeshi: Higanbana", "Kaeshi: Goken",
    "Kaeshi: Setsugekka", "Kenki Mastery", "Kenki Mastery II", "Way of the Samurai", "Enhanced Iaijutsu", "Enhanced Fugetsu and Fuka",
    "Enhanced Tsubame-gaeshi", "Way of the Samurai II", "Fuga Mastery", "Enhanced Meikyo Shisui", "Enhanced Ikishoten", "Hissatsu: Soten",
    "Hissatsu: Chiten", "Mineuchi", "Hyosetsu", "Zantetsuken", "Slice", "Waxing Slice", "Shadow of Death", "Harpe", "Hell's Ingress",
    "Hell's Egress", "Spinning Scythe", "Infernal Slice", "Whorl of Death", "Arcane Crest", "Nightmare Scythe", "Blood Stalk", "Grim Swathe",
    "Soul Slice", "Soul Scythe", "Gibbet", "Gallows", "Guillotine", "Unveiled Gibbet", "Unveiled Gallows", "Arcane Circle", "Regress", "Gluttony",
    "Enshroud", "Void Reaping", "Cross Reaping", "Grim Reaping", "Soulsow", "Harvest Moon", "Lemure's Slice", "Lemure's Scythe",
    "Plentiful Harvest", "Communio", "Soul Gauge", "Death Scythe Mastery", "Enhanced Avatar", "Hellsgate", "Tempered Soul", "Shroud Gauge",
    "Enhanced Arcane Crest", "Death Scythe Mastery II", "Enhanced Shroud", "Enhanced Arcane Circle", "Death Warrant", "Tenebrae Lemurum",
    "Heavy Shot", "Straight Shot", "Raging Strikes", "Venomous Bite", "Bloodletter", "Repelling Shot", "Quick Nock", "Windbite", "Mage's Ballad",
    "The Warden's Paean", "Barrage", "Army's Paeon", "Rain of Death", "Battle Voice", "The Wanderer's Minuet", "Pitch Perfect", "Empyreal Arrow",
    "Iron Jaws", "Sidewinder", "Troubadour", "Caustic Bite", "Stormbite", "Nature's Minne", "Refulgent Arrow", "Shadowbite", "Burst Shot",
    "Apex Arrow", "Ladonsbite", "Blast Arrow", "Radiant Finale", "Leg Graze", "Foot Graze", "Peloton", "Head Graze", "Heavier Shot",
    "Increased Action Damage", "Increased Action Damage II", "Bite Mastery", "Enhanced Empyreal Arrow", "Straight Shot Mastery",
    "Enhanced Quick Nock", "Bite Mastery II", "Heavy Shot Mastery", "Enhanced Army's Paeon", "Soul Voice", "Quick Nock Mastery",
    "Enhanced Bloodletter", "Enhanced Apex Arrow", "Enhanced Troubadour", "Minstrel's Coda", "Powerful Shot", "Silent Nocturne", "Final Fantasia",
    "Split Shot", "Slug Shot", "Hot Shot", "Reassemble", "Gauss Round", "Spread Shot", "Clean Shot", "Hypercharge", "Heat Blast", "Rook Autoturret",
    "Rook Overdrive", "Rook Overload", "Wildfire", "Detonator", "Ricochet", "Auto Crossbow", "Heated Split Shot", "Tactician", "Drill",
    "Heated Slug Shot", "Dismantle", "Heated Clean Shot", "Barrel Stabilizer", "Flamethrower", "Bioblaster", "Air Anchor", "Automaton Queen",
    "Queen Overdrive", "Arm Punch", "Roller Dash", "Pile Bunker", "Scattergun", "Crowned Collider", "Chain Saw", "Split Shot Mastery",
    "Slug Shot Mastery", "Clean Shot Mastery", "Charged Action Mastery", "Hot Shot Mastery", "Enhanced Wildfire", "Promotion", "Spread Shot Mastery",
    "Enhanced Reassemble", "Marksman's Mastery", "Queen's Gambit", "Enhanced Tactician", "Blast Charge", "Bishop Autoturret", "Analysis",
    "Aether Mortar", "Marksman's Spite", "Cascade", "Fountain", "Windmill", "Standard Step", "Standard Finish", "Reverse Cascade", "Bladeshower",
    "Fan Dance", "Rising Windmill", "Fountainfall", "Bloodshower", "Fan Dance II", "En Avant", "Curing Waltz", "Shield Samba", "Closed Position",
    "Ending", "Devilment", "Fan Dance III", "Technical Step", "Technical Finish", "Flourish", "Saber Dance", "Improvisation", "Improvised Finish",
    "Tillana", "Fan Dance IV", "Starfall Dance", "Emboite", "Entrechat", "Jete", "Pirouette", "Fourfold Fantasy", "Enhanced En Avant", "Esprit",
    "Enhanced En Avant II", "Enhanced Technical Finish", "Enhanced Esprit", "Enhanced Flourish", "Enhanced Shield Samba", "Enhanced Devilment",
    "Honing Dance", "Honing Ovation", "Contradance", "Blizzard", "Fire", "Transpose", "Thunder", "Blizzard II", "Scathe", "Fire II", "Thunder II",
    "Manaward", "Manafont", "Fire III", "Blizzard III", "Freeze", "Thunder III", "Aetherial Manipulation", "Flare", "Ley Lines", "Sharpcast",
    "Blizzard IV", "Fire IV", "Between the Lines", "Thunder IV", "Triplecast", "Foul", "Despair", "Umbral Soul", "Xenoglossy", "High Fire II",
    "High Blizzard II", "Amplifier", "Paradox", "Addle", "Sleep", "Aspect Mastery", "Aspect Mastery II", "Thundercloud", "Aspect Mastery III",
    "Firestarter", "Thunder Mastery", "Enochian", "Enhanced Freeze", "Thunder Mastery II", "Enhanced Enochian", "Enhanced Sharpcast",
    "Enhanced Enochian II", "Enhanced Polyglot", "Enhanced Foul", "Aspect Mastery IV", "Enhanced Manafont", "Enhanced Enochian III",
    "Enhanced Sharpcast II", "Aspect Mastery V", "Burst", "Night Wing", "Superflare", "Soul Resonance", "Summon Carbuncle", "Radiant Aegis",
    "Aethercharge", "Summon Ruby", "Gemshine", "Ruby Ruin", "Fester", "Summon Topaz", "Topaz Ruin", "Summon Emerald", "Emerald Ruin", "Outburst",
    "Precious Brilliance", "Ruby Outburst", "Topaz Outburst", "Emerald Outburst", "Summon Ifrit", "Ruby Ruin II", "Topaz Ruin II", "Emerald Ruin II",
    "Summon Titan", "Painflare", "Summon Garuda", "Energy Siphon", "Ruin III", "Ruby Ruin III", "Topaz Ruin III", "Emerald Ruin III", "Dreadwyrm Trance",
    "Astral Impulse", "Astral Flare", "Astral Flow", "Deathflare", "Ruin IV", "Searing Light", "Summon Bahamut", "Wyrmwave", "Enkindle Bahamut",
    "Akh Morn", "Ruby Rite", "Topaz Rite", "Emerald Rite", "Tri-disaster", "Ruby Disaster", "Topaz Disaster", "Emerald Disaster", "Fountain of Fire",
    "Brand of Purgatory", "Summon Phoenix", "Everlasting Flight", "Rekindle", "Scarlet Flame", "Enkindle Phoenix", "Revelation", "Ruby Catastrophe",
    "Topaz Catastrophe", "Emerald Catastrophe", "Crimson Cyclone", "Crimson Strike", "Mountain Buster", "Slipstream", "Summon Ifrit II",
    "Summon Titan II", "Summon Garuda II", "Enhanced Aethercharge", "Enhanced Aethercharge II", "Ruin Mastery", "Ruby Summoning Mastery",
    "Topaz Summoning Mastery", "Emerald Summoning Mastery", "Enkindle", "Ruin Mastery II", "Aethercharge Mastery", "Enhanced Energy Siphon",
    "Enhanced Dreadwyrm Trance", "Ruin Mastery III", "Outburst Mastery", "Enhanced Summon Bahamut", "Outburst Mastery II", "Ruin Mastery IV",
    "Elemental Mastery", "Enhanced Radiant Aegis", "Enkindle II", "Megaflare", "Riposte", "Jolt", "Verthunder", "Corps-a-corps", "Veraero",
    "Scatter", "Verthunder II", "Veraero II", "Verfire", "Verstone", "Zwerchhau", "Displacement", "Engagement", "Fleche", "Redoublement",
    "Acceleration", "Moulinet", "Vercure", "Contre Sixte", "Embolden", "Manafication", "Jolt II", "Verraise", "Impact", "Verflare", "Verholy",
    "Reprise", "Scorch", "Verthunder III", "Veraero III", "Magick Barrier", "Resolution", "Enchanted Riposte", "Enchanted Zwerchhau",
    "Enchanted Redoublement", "Enchanted Moulinet", "Enchanted Reprise", "Dualcast", "Enhanced Jolt", "Scatter Mastery", "Mana Stack",
    "Enhanced Displacement", "Red Magic Mastery", "Enhanced Manafication", "Red Magic Mastery II", "Red Magic Mastery III", "Enhanced Acceleration",
    "Enhanced Manafication II", "Black Shift", "Frazzle", "White Shift", "Southern Cross", "Paladin", "Warrior", "Dark Knight", "Gunbreaker",
    "White Mage", "Scholar", "Astrologian", "Sage", "Monk", "Dragoon", "Ninja", "Samurai", "Reaper", "Bard", "Machinist", "Dancer", "Black Mage",
    "Summoner", "Red Mage", "Blue Mage"
)

$lines = Get-Content $originalLogFilePath

$extractedLines = @()

foreach ($line in $lines) {
    if ($line -match "readies|starts casting|uses" -and $line -notmatch $characterName) {
        $containsAbility = $false
        foreach ($ability in $abilitiesToExclude) {
            if ($line -match $ability) {
                $containsAbility = $true
                break
            }
        }
        if (-not $containsAbility) {
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