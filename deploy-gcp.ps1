# Deploy Practice121 static website to Google Cloud Storage (note365 project)
# Usage: .\deploy-gcp.ps1

$ErrorActionPreference = "Stop"

$PROJECT = "note365"
$BUCKET = "practice121-static-web"
$REGION = "asia-southeast1"
$ROOT = $PSScriptRoot

Write-Host "Setting GCP project to $PROJECT..."
gcloud config set project $PROJECT | Out-Null

Write-Host "Ensuring bucket gs://$BUCKET exists..."
$bucketCheck = gsutil ls -b "gs://$BUCKET/" 2>&1
if ($LASTEXITCODE -ne 0) {
  gsutil mb -p $PROJECT -l $REGION -b on "gs://$BUCKET/"
  gsutil web set -m index.html -e index.html "gs://$BUCKET/"
  gsutil iam ch allUsers:objectViewer "gs://$BUCKET/"
}

Write-Host "Uploading site files..."
gsutil -m cp "$ROOT\index.html" "$ROOT\privacy-policy.html" "$ROOT\terms-and-conditions.html" "gs://$BUCKET/"
gsutil -m cp -r "$ROOT\css" "gs://$BUCKET/"
if (Test-Path "$ROOT\images\hero.jpg") {
  gsutil -m cp -r "$ROOT\images" "gs://$BUCKET/"
}

Write-Host ""
Write-Host "Deployment complete."
Write-Host "Site URL: https://storage.googleapis.com/$BUCKET/index.html"
Write-Host "Privacy:  https://storage.googleapis.com/$BUCKET/privacy-policy.html"
Write-Host "Terms:    https://storage.googleapis.com/$BUCKET/terms-and-conditions.html"
