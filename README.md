# Practice 121 - Static Website

A static HTML website for [practice121.com](https://practice121.com), ready to deploy on GoDaddy.

## Pages

| File | URL |
|------|-----|
| `index.html` | `/` (Home) |
| `privacy-policy.html` | `/privacy-policy.html` |
| `terms-and-conditions.html` | `/terms-and-conditions.html` |

## Project Structure

```
practice121-main-static-web/
├── index.html
├── privacy-policy.html
├── terms-and-conditions.html
├── css/
│   └── styles.css
├── images/
│   └── hero.jpg          ← Add your hero background image here
└── README.md
```

## Before Deploying

1. **Hero image** — Place your hero background photo at `images/hero.jpg` (recommended size: 1920×1080 or larger). The current design falls back to a green tint if the image is missing.

2. **Contact email** — Update `info@practice121.com` in all HTML files if your contact address is different.

3. **Legal content** — Review the Privacy Policy and Terms & Conditions text and customize as needed for your practice and jurisdiction.

## Deploy to Google Cloud (note365)

This site is hosted in the **note365** GCP project on Google Cloud Storage.

| Page | URL |
|------|-----|
| Home | https://storage.googleapis.com/practice121-static-web/index.html |
| Privacy Policy | https://storage.googleapis.com/practice121-static-web/privacy-policy.html |
| Terms & Conditions | https://storage.googleapis.com/practice121-static-web/terms-and-conditions.html |

**Bucket:** `gs://practice121-static-web`  
**Region:** `asia-southeast1`

### Deploy / update

From the project folder:

```powershell
.\deploy-gcp.ps1
```

Or manually:

```powershell
gcloud config set project note365
gsutil -m cp index.html privacy-policy.html terms-and-conditions.html gs://practice121-static-web/
gsutil -m cp -r css gs://practice121-static-web/
gsutil -m cp -r images gs://practice121-static-web/
```

### Custom domain (practice121.com)

To serve this site on your GoDaddy domain with HTTPS, point DNS to a Google Cloud Load Balancer or use Firebase Hosting in front of the bucket. The bucket URL above works immediately for testing and app store policy links.

## Deploy to GoDaddy

### Option A: GoDaddy Web Hosting (cPanel / File Manager)

1. Log in to your GoDaddy account.
2. Open **Web Hosting** → **Manage** → **File Manager** (or use FTP).
3. Navigate to `public_html` (your site's root folder).
4. Upload all files and folders from this project, keeping the same structure.
5. Ensure `index.html` is in the root of `public_html`.

### Option B: GoDaddy Website Builder → Custom HTML

If you're using GoDaddy's site builder, you may need to link to these pages from your existing site or switch to cPanel hosting for full static file control.

### Option C: FTP

Use an FTP client (FileZilla, etc.) with your GoDaddy FTP credentials:

- **Host:** Your domain or FTP hostname from GoDaddy
- **Remote directory:** `/public_html`
- Upload the entire project contents

## Local Preview

Open `index.html` in your browser, or run a simple local server:

```bash
# Python 3
python -m http.server 8080
```

Then visit `http://localhost:8080`.

## Contact Form

The contact form uses a `mailto:` action, which opens the user's email client. For a more reliable form on static hosting, consider:

- [Formspree](https://formspree.io/)
- [Netlify Forms](https://www.netlify.com/products/forms/) (if hosting elsewhere)
- GoDaddy's built-in form tools

Replace the `<form>` tag's `action` attribute with your chosen service's endpoint.
