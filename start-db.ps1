# ============================================================
# Practice121 - Start Cloud SQL Database
# Starts practice121fe instance (activation-policy=ALWAYS)
# ============================================================

$PROJECT = "note365"
$INSTANCE = "practice121fe"

Write-Host "Starting Cloud SQL instance '$INSTANCE' in project '$PROJECT'..." -ForegroundColor Cyan
gcloud sql instances patch $INSTANCE --project=$PROJECT --activation-policy=ALWAYS --quiet

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Database successfully started and ready for connections!" -ForegroundColor Green
    gcloud sql instances describe $INSTANCE --project=$PROJECT --format="table(name,tier,primaryAddress,status)"
} else {
    Write-Host "Failed to start database. Check gcloud credentials/permissions." -ForegroundColor Red
}
