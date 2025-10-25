# Script d'affichage des variables d'environnement
Write-Host "📊 VARIABLES D'ENVIRONNEMENT ACTUELLES" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

Write-Host "`n🔍 ANALYSE DU FICHIER .env ACTUEL:" -ForegroundColor Yellow

if (Test-Path ".env") {
    Write-Host "✅ Fichier .env trouvé" -ForegroundColor Green
    
    # Lire et analyser le fichier .env
    $envContent = Get-Content ".env"
    $variables = @{}
    $comments = @()
    
    foreach ($line in $envContent) {
        if ($line.StartsWith("#")) {
            $comments += $line
        } elseif ($line -match "^([^=]+)=(.*)$") {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            $variables[$key] = $value
        }
    }
    
    Write-Host "`n📋 VARIABLES CONFIGURÉES:" -ForegroundColor Cyan
    Write-Host "========================" -ForegroundColor Cyan
    
    # Catégoriser et afficher les variables
    $categories = @{
        "🌐 ENVIRONNEMENT" = @("NODE_ENV", "PORT", "VERCEL")
        "🔗 API" = @("NEXT_PUBLIC_API_URL", "API_BASE_URL")
        "🔒 SÉCURITÉ" = @("SESSION_SECRET", "JWT_SECRET")
        "🌍 CORS" = @("CORS_ORIGIN", "ALLOWED_ORIGINS")
        "💾 BASE DE DONNÉES" = @("DATABASE_URL", "MONGODB_URI", "SQLITE_DB_PATH")
        "📁 STOCKAGE" = @("UPLOAD_DIR", "MAX_FILE_SIZE", "ALLOWED_FILE_TYPES")
        "📧 EMAIL" = @("SMTP_HOST", "SMTP_PORT", "SMTP_USER", "SMTP_PASS", "FROM_EMAIL")
        "☁️ SERVICES CLOUD" = @("CLOUDINARY_CLOUD_NAME", "CLOUDINARY_API_KEY", "CLOUDINARY_API_SECRET")
        "🐛 DEBUG" = @("DEBUG", "LOG_LEVEL")
    }
    
    foreach ($category in $categories.GetEnumerator()) {
        Write-Host "`n$($category.Key):" -ForegroundColor Yellow
        
        foreach ($varName in $category.Value) {
            if ($variables.ContainsKey($varName)) {
                $value = $variables[$varName]
                if ($value -eq "") {
                    Write-Host "  $varName = (vide/non configuré)" -ForegroundColor Gray
                } elseif ($varName -like "*SECRET*" -or $varName -like "*PASS*" -or $varName -like "*KEY*") {
                    Write-Host "  $varName = ******* (masqué)" -ForegroundColor Magenta
                } else {
                    Write-Host "  $varName = $value" -ForegroundColor White
                }
            } else {
                Write-Host "  $varName = (non défini)" -ForegroundColor Red
            }
        }
    }
    
    # Variables non catégorisées
    $knownVars = $categories.Values | ForEach-Object { $_ } | Sort-Object -Unique
    $unknownVars = $variables.Keys | Where-Object { $_ -notin $knownVars }
    
    if ($unknownVars.Count -gt 0) {
        Write-Host "`n🔍 AUTRES VARIABLES:" -ForegroundColor Yellow
        foreach ($var in $unknownVars) {
            Write-Host "  $var = $($variables[$var])" -ForegroundColor White
        }
    }
    
} else {
    Write-Host "❌ Aucun fichier .env trouvé" -ForegroundColor Red
}

# Afficher les autres fichiers d'environnement disponibles
Write-Host "`n📁 AUTRES CONFIGURATIONS DISPONIBLES:" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Yellow

$envFiles = @(
    @{Name=".env.nouveau-serveur"; Desc="Production Vercel"},
    @{Name=".env.local.nouveau"; Desc="Développement local"},
    @{Name=".env.example"; Desc="Exemple/Template"},
    @{Name=".env.local"; Desc="Local (ancien)"},
    @{Name=".env.production"; Desc="Production (ancien)"}
)

foreach ($file in $envFiles) {
    if (Test-Path $file.Name) {
        Write-Host "✅ $($file.Name) - $($file.Desc)" -ForegroundColor Green
    } else {
        Write-Host "❌ $($file.Name) - $($file.Desc) (manquant)" -ForegroundColor Red
    }
}

Write-Host "`n🎯 STATUT ACTUEL:" -ForegroundColor Cyan
Write-Host "===============" -ForegroundColor Cyan

if (Test-Path ".env") {
    $nodeEnv = $variables["NODE_ENV"]
    $apiUrl = $variables["NEXT_PUBLIC_API_URL"]
    
    if ($nodeEnv -eq "production") {
        Write-Host "🚀 MODE: Production Vercel" -ForegroundColor Green
    } elseif ($nodeEnv -eq "development") {
        Write-Host "🏠 MODE: Développement local" -ForegroundColor Blue
    } else {
        Write-Host "❓ MODE: Non défini" -ForegroundColor Yellow
    }
    
    if ($apiUrl) {
        if ($apiUrl -like "*localhost*") {
            Write-Host "🔗 API: Local ($apiUrl)" -ForegroundColor Blue
        } elseif ($apiUrl -like "*vercel.app*") {
            Write-Host "🔗 API: Vercel ($apiUrl)" -ForegroundColor Green
        } else {
            Write-Host "🔗 API: Autre ($apiUrl)" -ForegroundColor Yellow
        }
    }
}

Write-Host "`n💡 ACTIONS SUGGÉRÉES:" -ForegroundColor Yellow
Write-Host "• Pour basculer entre environnements: ./switch-env.ps1" -ForegroundColor Cyan
Write-Host "• Pour configurer Vercel: ./config-env-vercel.ps1" -ForegroundColor Cyan
Write-Host "• Variables vides à remplir selon vos besoins" -ForegroundColor Cyan

Write-Host "`n✨ Analyse terminée!" -ForegroundColor Green
