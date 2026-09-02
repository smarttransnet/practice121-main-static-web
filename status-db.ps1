# ============================================================
# Practice121 - Check Cloud SQL Database Status
# Displays tier, IP, storage, auto-resize, and state
# ============================================================

$PROJECT = "note365"
$INSTANCE = "practice121fe"

Write-Host "Fetching status for Cloud SQL instance '$INSTANCE'..." -ForegroundColor Cyan
gcloud sql instances describe $INSTANCE --project=$PROJECT --format="table(name,settings.tier:label=TIER,settings.activationPolicy:label=POWER_POLICY,settings.storageAutoResize:label=AUTO_RESIZE,primaryAddress:label=PUBLIC_IP,state:label=STATE)"
