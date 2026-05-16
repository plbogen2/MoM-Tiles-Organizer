param(
    [switch]$RenderPng = $false
)

# 1. FIND OPENSCAD INSTALLATION
$possiblePaths = @(
    "$env:LOCALAPPDATA\Programs\OpenSCAD",
    "$env:LOCALAPPDATA\OpenSCAD",
    "C:\Program Files\OpenSCAD",
    "C:\Program Files (x86)\OpenSCAD",
    "/usr/bin", # For Linux (GitHub Actions)
    "/usr/local/bin"
)

$osPath = ""
$exeName = if ($IsWindows -or $env:OS -like "*Windows*") { "openscad.com" } else { "openscad" }

foreach ($p in $possiblePaths) {
    if (Test-Path "$p/$exeName") {
        $osPath = "$p/$exeName"
        break
    }
}

if ($osPath -eq "") {
    $osPath = Get-Command $exeName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
}

if (!$osPath) {
    Write-Host "ERROR: OpenSCAD not found." -ForegroundColor Red
    return
}

# 2. SETUP DIRECTORIES
$stlDir = "./STLs"
$pngDir = "./PNGs"

if (!(Test-Path $stlDir)) { New-Item -ItemType Directory -Path $stlDir }
if ($RenderPng -and !(Test-Path $pngDir)) { New-Item -ItemType Directory -Path $pngDir }

Write-Host "--- Starting Render Loop ---" -ForegroundColor Cyan
Write-Host "Using OpenSCAD at: $osPath"

# 3. PILLAR RENDER
$pillars = @{
    "mom_pillar_left.scad"  = "mom_pillar_left.stl"
    "mom_pillar_right.scad" = "mom_pillar_right.stl"
}

foreach ($scadFile in $pillars.Keys) {
    $stlFile = "$stlDir/$($pillars[$scadFile])"
    Write-Host "Rendering Pillar: $scadFile -> $stlFile" -ForegroundColor Yellow
    if (!(Test-Path $scadFile)) { continue }
    if (Test-Path $stlFile) { Remove-Item $stlFile }
    & $osPath -o $stlFile --enable manifold $scadFile
    if ((Test-Path $stlFile) -and (Get-Item $stlFile).Length -gt 0) { Write-Host "  [STL] Success" -ForegroundColor Green }
}

# 4. TRAY RENDER LOOP
$trayCount = 46
for ($i = 0; $i -lt $trayCount; $i++) {
    $stlFile = "$stlDir/mom_tray_$i.stl"
    Write-Host "Rendering Tray: $i -> $stlFile" -ForegroundColor Yellow
    
    if (Test-Path $stlFile) { Remove-Item $stlFile }
    $stlArgs = @( "-o", $stlFile, "-D", "tray_index=$i", "--enable", "manifold", "mansions_tiles.scad" )
    & $osPath $stlArgs

    if ((Test-Path $stlFile) -and (Get-Item $stlFile).Length -gt 0) {
        Write-Host "  [STL] Success" -ForegroundColor Green
    } else {
        Write-Host "  [STL] Failed" -ForegroundColor Red
    }
}

# 5. PREVIEW RENDER
if ($RenderPng) {
    $assemblyFile = "mom_assembly.scad"
    $pngFile = "$pngDir/preview.png"
    
    if (Test-Path $assemblyFile) {
        Write-Host "Rendering Preview: $assemblyFile" -ForegroundColor Yellow
        if (Test-Path $pngFile) { Remove-Item $pngFile }
        
        # Consistent camera settings from original workflow
        $pngArgs = @(
            "-o", $pngFile,
            "--imgsize", "1280,720",
            "--camera", "150,100,100,55,0,25,1200",
            "--enable", "manifold",
            $assemblyFile
        )
        & $osPath $pngArgs
        
        if (Test-Path $pngFile) {
            Write-Host "  [PNG] Success" -ForegroundColor Green
        }
    }
}

Write-Host "--- All Processes Complete ---" -ForegroundColor Cyan
