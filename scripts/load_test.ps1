# MedBook Load Test - PowerShell version
# Usage: .\load_test.ps1 -Users 20 -Duration 60

param(
    [int]$Users = 10,
    [int]$Duration = 60
)

$Backend = "http://localhost:3000"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host " MedBook Load Test Starting" -ForegroundColor Cyan
Write-Host " Concurrent users : $Users" -ForegroundColor Cyan
Write-Host " Duration         : ${Duration}s" -ForegroundColor Cyan
Write-Host " Target           : $Backend" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

$EndTime = (Get-Date).AddSeconds($Duration)

$scriptBlock = {
    param($backend, $endTime, $userId)
    $count = 0
    while ((Get-Date) -lt $endTime) {
        try {
            # Root check
            Invoke-WebRequest -Uri "$backend/" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue | Out-Null
            # Get appointments
            Invoke-WebRequest -Uri "$backend/api/appointments" -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue | Out-Null
            # Create appointment
            $body = '{"patient":"TestUser' + $userId + '","date":"2026-06-01","doctor":"Dr. Test"}'
            Invoke-WebRequest -Uri "$backend/api/appointments" -Method POST `
                -ContentType "application/json" -Body $body `
                -UseBasicParsing -TimeoutSec 5 -ErrorAction SilentlyContinue | Out-Null
            $count++
        } catch {}
        Start-Sleep -Milliseconds 500
    }
    Write-Host "User $userId finished - $count cycles" -ForegroundColor Green
}

# Launch all users as background jobs
$jobs = @()
for ($i = 1; $i -le $Users; $i++) {
    $jobs += Start-Job -ScriptBlock $scriptBlock -ArgumentList $Backend, $EndTime, $i
}

Write-Host "All $Users users running..." -ForegroundColor Yellow
Write-Host "Watch Grafana:    http://localhost:3001" -ForegroundColor Yellow
Write-Host "Watch Prometheus: http://localhost:9090" -ForegroundColor Yellow

# Wait for all jobs
$jobs | Wait-Job | Out-Null
$jobs | Receive-Job
$jobs | Remove-Job

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host " Load test complete! Check Grafana." -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan