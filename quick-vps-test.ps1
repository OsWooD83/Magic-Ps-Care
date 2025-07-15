# Test rapide de connectivité VPS
# Usage: .\quick-vps-test.ps1 -IP "VOTRE_IP"

param([string]$IP)

if (-not $IP) {
    Write-Host "Usage: .\quick-vps-test.ps1 -IP 'VOTRE_IP_VPS'" -ForegroundColor Red
    exit
}

Write-Host "🔍 Test rapide de $IP" -ForegroundColor Blue

# Ping
$ping = Test-Connection -ComputerName $IP -Count 2 -Quiet
Write-Host "Ping: $(if($ping){'✅ OK'}else{'❌ KO'})" -ForegroundColor $(if($ping){'Green'}else{'Red'})

# SSH
$ssh = Test-NetConnection -ComputerName $IP -Port 22 -WarningAction SilentlyContinue
Write-Host "SSH (22): $(if($ssh.TcpTestSucceeded){'✅ OK'}else{'❌ KO'})" -ForegroundColor $(if($ssh.TcpTestSucceeded){'Green'}else{'Red'})

# HTTP
$http = Test-NetConnection -ComputerName $IP -Port 80 -WarningAction SilentlyContinue
Write-Host "HTTP (80): $(if($http.TcpTestSucceeded){'✅ OK'}else{'❌ KO'})" -ForegroundColor $(if($http.TcpTestSucceeded){'Green'}else{'Red'})

if ($ping -and $ssh.TcpTestSucceeded) {
    Write-Host "
✅ VPS accessible - Vous pouvez déployer" -ForegroundColor Green
    Write-Host "Commande: ssh root@$IP" -ForegroundColor Gray
} elseif ($ssh.TcpTestSucceeded) {
    Write-Host "
⚠️ SSH OK mais ping bloqué - Normal, vous pouvez déployer" -ForegroundColor Yellow
    Write-Host "Commande: ssh root@$IP" -ForegroundColor Gray
} else {
    Write-Host "
❌ VPS inaccessible - Vérifiez le panel Hostinger" -ForegroundColor Red
}
