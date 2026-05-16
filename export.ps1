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

# 2. DEFINE TARGETS
# Mapping of Source SCAD -> Output STL
$targets = @{
    "mom_pillar_left.scad"  = "mom_pillar_left.stl"
    "mom_pillar_right.scad" = "mom_pillar_right.stl"
}

$stlDir = "./STLs"
$pngDir = "./PNGs"

if (!(Test-Path $stlDir)) { New-Item -ItemType Directory -Path $stlDir }
if ($RenderPng -and !(Test-Path $pngDir)) { New-Item -ItemType Directory -Path $pngDir }

Write-Host "--- Starting Render Loop ---" -ForegroundColor Cyan
Write-Host "Using OpenSCAD at: $osPath"

foreach ($scadFile in $targets.Keys) {
    $stlFile = "$stlDir/$($targets[$scadFile])"
    
    Write-Host "Rendering STL: $scadFile -> $stlFile" -ForegroundColor Yellow
    
    # Check if file exists
    if (!(Test-Path $scadFile)) {
        Write-Host "  [SKIP] $scadFile not found" -ForegroundColor DarkGray
        continue
    }

    if (Test-Path $stlFile) { Remove-Item $stlFile }
    
    # Run OpenSCAD with manifold enabled for speed
    $stlArgs = @( "-o", $stlFile, "--enable", "manifold", $scadFile )
    & $osPath $stlArgs

    if ((Test-Path $stlFile) -and (Get-Item $stlFile).Length -gt 0) {
        Write-Host "  [STL] Success" -ForegroundColor Green
    } else {
        Write-Host "  [STL] Failed" -ForegroundColor Red
    }
}

# 3. PREVIEW RENDER
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
