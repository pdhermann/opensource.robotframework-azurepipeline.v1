$robots = @{}
$robotsPath = Join-Path "$env:SYSTEM_DEFAULTWORKINGDIRECTORY" "src"

$folder = Get-ChildItem -Path $robotsPath -Recurse -Filter *.robot | Select-Object -ExpandProperty DirectoryName -Unique
foreach($f in $folder){
  $log = $f -match "([/a-zA-Z0-9\:\\]+src{1}[/\\]{1})(?<robot>[a-zA-Z0-9\-]+)[/\\]+([a-zA-Z0-9\s/\\]+)"
  $fo = $Matches.robot
  if($env:DEBUGMODE -eq 'True') {
    Write-Host "##[debug]$fo"
  }
  if(!$robots.Contains($fo) -and $fo -notlike "*.*" -and $fo -notlike ""){
    $robot = @{'robot' = $fo}
    $robots[$fo] = $robot
    Write-Host "Robot $fo added."
  }
}

$json = ConvertTo-Json $robots -Compress
Write-Host "##vso[task.setvariable variable=ALL_ROBOTS;isOutput=true]$json"
