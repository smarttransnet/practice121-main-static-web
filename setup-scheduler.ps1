# ============================================================
# Practice121 - Setup Automated Start/Stop Schedule in GCP
# Uses Google Cloud Scheduler + Cloud SQL Admin REST API
#
# Schedule:
# - Auto-Start: Monday to Friday at 07:30 AM (Asia/Colombo)
# - Auto-Stop:  Monday to Friday at 08:00 PM (Asia/Colombo)
# - Weekends:   OFF (Saturday & Sunday completely stopped)
# ============================================================

$PROJECT = "note365"
$INSTANCE = "practice121fe"
$LOCATION = "asia-southeast1"
$TIMEZONE = "Asia/Colombo"
$SA_NAME = "cloudsql-scheduler-sa"
$SA_EMAIL = "$SA_NAME@$PROJECT.iam.gserviceaccount.com"

Write-Host "Configuring Automated Database Scheduler for '$INSTANCE'..." -ForegroundColor Cyan

# 1. Enable Cloud Scheduler API
Write-Host "1. Enabling Cloud Scheduler API..."
gcloud services enable cloudscheduler.googleapis.com --project=$PROJECT --quiet

# 2. Create Service Account if not existing
Write-Host "2. Setting up Service Account for Scheduler..."
$saExists = gcloud iam service-accounts list --project=$PROJECT --filter="email=$SA_EMAIL" --format="value(email)" 2>&1
if (-not $saExists) {
    gcloud iam service-accounts create $SA_NAME `
      --project=$PROJECT `
      --display-name="Cloud SQL Auto Start/Stop Scheduler" --quiet
}

# 3. Grant Cloud SQL Editor role to Service Account
Write-Host "3. Granting Cloud SQL permissions..."
gcloud projects add-iam-policy-binding $PROJECT `
  --member="serviceAccount:$SA_EMAIL" `
  --role="roles/cloudsql.editor" --quiet

# 4. Create/Update Auto-Start Job (7:30 AM Mon-Fri)
Write-Host "4. Creating Auto-Start Schedule (07:30 AM Mon-Fri)..."
$startJobExists = gcloud scheduler jobs list --project=$PROJECT --location=$LOCATION --filter="name:start-sql-db" --format="value(name)" 2>&1
if ($startJobExists) {
    gcloud scheduler jobs delete start-sql-db --project=$PROJECT --location=$LOCATION --quiet
}

gcloud scheduler jobs create http start-sql-db `
  --project=$PROJECT `
  --location=$LOCATION `
  --schedule="30 7 * * 1-5" `
  --time-zone=$TIMEZONE `
  --uri="https://sqladmin.googleapis.com/v1/projects/$PROJECT/instances/$INSTANCE" `
  --http-method=PATCH `
  --headers="Content-Type=application/json" `
  --message-body='{\"settings\": {\"activationPolicy\": \"ALWAYS\"}}' `
  --oauth-service-account-email=$SA_EMAIL `
  --oauth-token-scope="https://www.googleapis.com/auth/cloud-platform" `
  --description="Auto-start Cloud SQL database on weekday mornings" `
  --quiet

# 5. Create/Update Auto-Stop Job (8:00 PM Mon-Fri)
Write-Host "5. Creating Auto-Stop Schedule (08:00 PM Mon-Fri)..."
$stopJobExists = gcloud scheduler jobs list --project=$PROJECT --location=$LOCATION --filter="name:stop-sql-db" --format="value(name)" 2>&1
if ($stopJobExists) {
    gcloud scheduler jobs delete stop-sql-db --project=$PROJECT --location=$LOCATION --quiet
}

gcloud scheduler jobs create http stop-sql-db `
  --project=$PROJECT `
  --location=$LOCATION `
  --schedule="0 20 * * 1-5" `
  --time-zone=$TIMEZONE `
  --uri="https://sqladmin.googleapis.com/v1/projects/$PROJECT/instances/$INSTANCE" `
  --http-method=PATCH `
  --headers="Content-Type=application/json" `
  --message-body='{\"settings\": {\"activationPolicy\": \"NEVER\"}}' `
  --oauth-service-account-email=$SA_EMAIL `
  --oauth-token-scope="https://www.googleapis.com/auth/cloud-platform" `
  --description="Auto-stop Cloud SQL database on weekday evenings" `
  --quiet

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host " Automated Schedule Configured Successfully!" -ForegroundColor Green
Write-Host " - Auto-Start: Monday - Friday @ 07:30 AM ($TIMEZONE)" -ForegroundColor Yellow
Write-Host " - Auto-Stop:  Monday - Friday @ 08:00 PM ($TIMEZONE)" -ForegroundColor Yellow
Write-Host " - Weekends:   Paused (0 Compute Cost)" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Green
