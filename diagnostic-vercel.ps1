# Script de diagnostic Vercel
Write-Host "=== DIAGNOSTIC VERCEL ===" -ForegroundColor Cyan

# Test 1: Vérifier Node.js
Write-Host "`n1. Test Node.js:" -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js non trouvé" -ForegroundColor Red
    exit 1
}

# Test 2: Vérifier npm
Write-Host "`n2. Test npm:" -ForegroundColor Yellow
try {
    $npmVersion = npm --version
    Write-Host "✅ npm: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm non trouvé" -ForegroundColor Red
}

# Test 3: Vérifier Vercel CLI
Write-Host "`n3. Test Vercel CLI:" -ForegroundColor Yellow
try {
    $vercelPath = Get-Command vercel -ErrorAction Stop
    Write-Host "✅ Vercel CLI trouvé: $($vercelPath.Source)" -ForegroundColor Green
    
    # Tester la version (avec timeout)
    $job = Start-Job -ScriptBlock { vercel --version }
    if (Wait-Job $job -Timeout 5) {
        $version = Receive-Job $job
        Write-Host "✅ Version: $version" -ForegroundColor Green
    } else {
        Remove-Job $job -Force
        Write-Host "⚠️  Timeout lors de la vérification de version" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ Vercel CLI non trouvé - Installation requise" -ForegroundColor Red
    Write-Host "💡 Exécutez: npm install -g vercel" -ForegroundColor Cyan
    exit 1
}

# Test 4: Vérifier la structure du projet
Write-Host "`n4. Test structure du projet:" -ForegroundColor Yellow
if (Test-Path "vercel.json") {
    Write-Host "✅ vercel.json trouvé" -ForegroundColor Green
    
    # Vérifier le JSON
    try {
        $config = Get-Content "vercel.json" | ConvertFrom-Json
        Write-Host "✅ vercel.json est valide" -ForegroundColor Green
        Write-Host "   Nom du projet: $($config.name)" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ vercel.json invalide: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️  vercel.json non trouvé" -ForegroundColor Yellow
}

if (Test-Path "api") {
    $apiFiles = Get-ChildItem "api" -Filter "*.js" | Measure-Object
    Write-Host "✅ Dossier API trouvé ($($apiFiles.Count) fichiers)" -ForegroundColor Green
} else {
    Write-Host "⚠️  Dossier API non trouvé" -ForegroundColor Yellow
}

if (Test-Path "package.json") {
    Write-Host "✅ package.json trouvé" -ForegroundColor Green
} else {
    Write-Host "⚠️  package.json non trouvé" -ForegroundColor Yellow
}

# Test 5: Vérifier les processus bloquants
Write-Host "`n5. Test processus:" -ForegroundColor Yellow
$nodeProcesses = Get-Process -Name "node" -ErrorAction SilentlyContinue
if ($nodeProcesses) {
    Write-Host "⚠️  Processus Node.js en cours ($($nodeProcesses.Count)):" -ForegroundColor Yellow
    $nodeProcesses | ForEach-Object { Write-Host "   PID: $($_.Id) - $($_.ProcessName)" }
} else {
    Write-Host "✅ Aucun processus Node.js bloquant" -ForegroundColor Green
}

Write-Host "`n=== FIN DU DIAGNOSTIC ===" -ForegroundColor Cyan
Write-Host "💡 Si tout est vert, essayez: vercel --yes" -ForegroundColor Cyan
