# Solution alternative pour Vercel
Write-Host "=== SOLUTION ALTERNATIVE VERCEL ===" -ForegroundColor Cyan

Write-Host "1. Réinstallation de Vercel CLI..." -ForegroundColor Yellow
npm uninstall -g vercel 2>$null
npm install -g vercel@latest

Write-Host "`n2. Nettoyage complet..." -ForegroundColor Yellow
Remove-Item -Path ".vercel" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "node_modules/.cache" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "`n3. Test de la nouvelle installation..." -ForegroundColor Yellow
$version = vercel --version
Write-Host "✅ Vercel version: $version" -ForegroundColor Green

Write-Host "`n4. Création du projet (méthode alternative)..." -ForegroundColor Yellow
Write-Host "⏳ Initialisation..." -ForegroundColor Cyan

# Méthode alternative sans login interactif
$env:VERCEL_ORG_ID = ""
$env:VERCEL_PROJECT_ID = ""

# Créer un projet basique
vercel --yes --prod

Write-Host "✅ Projet créé!" -ForegroundColor Green
