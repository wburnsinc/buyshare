# PocketCash — Relaunch Guide

This guide explains how to completely relaunch PocketCash on a new account, host, or machine.

---

## Prerequisites

- Node.js 22+ (or 24 as used in development)
- pnpm 10+ (`npm install -g pnpm`)
- PostgreSQL 15+ (local or hosted)
- A Clerk account (https://clerk.com)

---

## 1. Import Source Code

### On Replit
1. Create a new Replit account.
2. Click "Import from GitHub" or "Upload."
3. Upload the ZIP archive OR connect to a GitHub fork of the repo.
4. Replit will detect the `pnpm-workspace.yaml` and install dependencies automatically.

### On Another Host (VPS, Railway, Render, etc.)
```bash
git clone <your-repo-url>
cd pocketcash
pnpm install
```

---

## 2. Install Dependencies

```bash
pnpm install
```

This installs all workspace packages (frontend, API server, DB, API spec libs).

---

## 3. Create the Database and Apply Schema

1. Create a PostgreSQL database on your host (Neon, Supabase, Railway, or local `pg`).
2. Copy the connection string.
3. Set `DATABASE_URL` in your environment (see Step 5).
4. Apply the schema:

```bash
pnpm --filter @workspace/db run push
```

This runs Drizzle Kit's push command and creates all tables automatically.

---

## 4. Import Exported Data (if migrating from existing instance)

If you exported data from the old instance:

```bash
# Restore a PostgreSQL dump
psql $DATABASE_URL < pocketcash_export.sql
```

Or use the database provider's restore tool (Neon, Supabase, etc.).

---

## 5. Configure Environment Variables

Copy `.env.example` to `.env` and fill in all values:

```bash
cp .env.example .env
# Edit .env with your real values
```

Required variables:
- `DATABASE_URL` — PostgreSQL connection string
- `CLERK_SECRET_KEY` — From https://dashboard.clerk.com
- `CLERK_PUBLISHABLE_KEY` — From Clerk dashboard
- `VITE_CLERK_PUBLISHABLE_KEY` — Same as above
- `SESSION_SECRET` — Run: `openssl rand -base64 48`

---

## 6. Restore Uploaded Files and Media

PocketCash currently stores user avatar URLs as external references (no file uploads stored on disk). No file restoration is needed.

If you added object storage in the future, restore from your S3/R2 bucket.

---

## 7. Run the Application

### Start API server (port 8080):
```bash
pnpm --filter @workspace/api-server run dev
```

### Start frontend (auto-assigned port):
```bash
pnpm --filter @workspace/pocketcash run dev
```

### Or run both with process manager:
```bash
# Using concurrently:
npx concurrently "pnpm --filter @workspace/api-server run dev" "pnpm --filter @workspace/pocketcash run dev"
```

---

## 8. Deploy to Production

### On Replit
Click "Publish" → "Autoscale" in the Replit workspace. Replit handles HTTPS, TLS, and domain automatically.

### On Railway / Render / Fly.io
1. Connect your GitHub repo.
2. Set all environment variables in the platform dashboard.
3. Set the start command to: `pnpm --filter @workspace/api-server run start`
4. Set the frontend build command to: `pnpm --filter @workspace/pocketcash run build`
5. Serve the built `artifacts/pocketcash/dist` folder as static files.

---

## 9. Connect a Custom Domain

### On Replit
Settings → Custom Domains → Add your domain → Follow DNS instructions.

### General
Point your domain's A record or CNAME to your host's IP or hostname. Add the domain to Clerk's "Allowed Origins" list in the Clerk dashboard.

---

## 10. Test Critical Features Before Going Live

Run through this checklist manually:

- [ ] Landing page loads at `/`
- [ ] Sign up with Google SSO works (redirects properly)
- [ ] Sign in works and redirects to `/dashboard`
- [ ] Dashboard loads borrowing + lending summaries
- [ ] Create a campaign → appears in /campaigns
- [ ] Contribute to a campaign → fee breakdown shows correctly
- [ ] Pocket Pool page loads and "Join Pool" button works
- [ ] Admin portal at `/admin` shows platform stats
- [ ] Notification bell shows unread count
- [ ] API health check: `curl <your-domain>/api/healthz`

---

## 11. Regenerate API Client After Spec Changes

If you change `lib/api-spec/openapi.yaml`:

```bash
pnpm --filter @workspace/api-spec run codegen
```

This regenerates all React Query hooks and Zod validation schemas.

---

## 12. Backup and Restore

### Backup database
```bash
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql
```

### Restore database
```bash
psql $DATABASE_URL < backup_YYYYMMDD.sql
```

Schedule daily backups via cron or your hosting provider's automatic backup feature.

---

## Architecture Summary

```
artifacts/
  api-server/       Express 5 API (port 8080), all backend routes
  pocketcash/       React + Vite frontend
lib/
  db/               Drizzle ORM schema + DB client
  api-spec/         OpenAPI spec (source of truth)
  api-client-react/ Orval-generated React Query hooks (DO NOT EDIT)
  api-zod/          Orval-generated Zod schemas (DO NOT EDIT)
```
