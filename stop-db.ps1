# ============================================================
# Practice121 - Stop Cloud SQL Database
# Stops practice121fe instance (activation-policy=NEVER)
# Compute cost drops to $0 while stopped.
# ============================================================

$PROJECT = "note365"
$INSTANCE = "practice121fe"

Write-Host "Stopping Cloud SQL instance '$INSTANCE' in project '$PROJECT'..." -ForegroundColor Yellow
Write-Host "Compute billing will be paused while the instance is stopped." -ForegroundColor DarkGray
gcloud sql instances patch $INSTANCE --project=$PROJECT --activation-policy=NEVER --quiet

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Database successfully stopped. (Compute billing: $0/hr)" -ForegroundColor Green
} else {
    Write-Host "Failed to stop database. Check gcloud credentials/permissions." -ForegroundColor Red
}
