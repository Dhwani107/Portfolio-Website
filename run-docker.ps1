#!/usr/bin/env pwsh
# Quick Docker startup script for Dhwani Portfolio

$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectDir

Write-Host "🚀 Starting Dhwani Portfolio via Docker..." -ForegroundColor Cyan

# Start containers
docker compose up -d --build

# Wait for app to be ready
Write-Host "⏳ Waiting for app to be ready..." -ForegroundColor Yellow
$maxWait = 30
$elapsed = 0
do {
    try {
        $response = Invoke-WebRequest -UseBasicParsing http://localhost:8080 -TimeoutSec 5 -ErrorAction SilentlyContinue
        if ($response.StatusCode -eq 200) {
            Write-Host "✅ App is ready!" -ForegroundColor Green
            break
        }
    }
    catch {
        Start-Sleep -Seconds 2
        $elapsed += 2
        if ($elapsed -lt $maxWait) {
            Write-Host "." -NoNewline -ForegroundColor Yellow
        }
    }
} while ($elapsed -lt $maxWait)

Write-Host ""
Write-Host "📱 Opening browser..." -ForegroundColor Cyan
Start-Process http://localhost:8080

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✨ Application Available" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "📌 Main URLs:" -ForegroundColor Cyan
Write-Host "   • Portfolio: http://localhost:8080" -ForegroundColor White
Write-Host "   • Login: http://localhost:8080/login.jsp" -ForegroundColor White
Write-Host "   • Dashboard: http://localhost:8080/jsp/dashboard.jsp" -ForegroundColor White
Write-Host ""
Write-Host "👤 Demo Credentials:" -ForegroundColor Cyan
Write-Host "   Username: dhwani_chauhan" -ForegroundColor White
Write-Host "   Password: demo@123456" -ForegroundColor White
Write-Host ""
Write-Host "📊 Features Available:" -ForegroundColor Cyan
Write-Host "   • Manage Projects (CRUD)" -ForegroundColor White
Write-Host "   • Manage Skills (CRUD)" -ForegroundColor White
Write-Host "   • View Contact Messages" -ForegroundColor White
Write-Host "   • Dark/Light Theme Toggle" -ForegroundColor White
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Commands:" -ForegroundColor Cyan
Write-Host "   View logs:  docker compose logs -f app" -ForegroundColor Gray
Write-Host "   Stop all:   docker compose down" -ForegroundColor Gray
Write-Host "   Stop + DB:  docker compose down -v" -ForegroundColor Gray
Write-Host ""
Write-Host "📚 Documentation: See MODULE6_IMPLEMENTATION.md for dashboard details" -ForegroundColor Gray
Write-Host ""
