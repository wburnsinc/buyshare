# EarnTree.co — Handover Verification Checklist

**Date:** June 26, 2025  
**Platform:** Replit (pnpm monorepo)  
**Status:** ✅ Handover package complete

---

## 1. Source Code Completeness

| Item | Status | Notes |
|---|---|---|
| Frontend — React + Vite (`artifacts/sharetree/`) | ✅ Included | 40+ pages and components |
| Backend — Express 5 API (`artifacts/api-server/`) | ✅ Included | All routes implemented |
| DB schema & ORM (`lib/db/`) | ✅ Included | Drizzle ORM, all tables |
| API client library (`lib/api-client-react/`) | ✅ Included | Generated from OpenAPI spec |
| OpenAPI specification (`lib/api-spec/`) | ✅ Included | Source of truth for API contract |
| Seed scripts (`scripts/src/seed.ts`) | ✅ Included | 12 categories, 5 network properties, settings |
| pnpm lockfile (`pnpm-lock.yaml`) | ✅ Included | Exact dependency versions locked |
| Workspace config (`pnpm-workspace.yaml`) | ✅ Included | |
| TypeScript config (`tsconfig*.json`) | ✅ Included | |
| Vite config (`artifacts/sharetree/vite.config.ts`) | ✅ Included | |
| Replit artifact config (`.replit-artifact/`) | ✅ Included | Workflow definitions |
| Public assets (`artifacts/sharetree/public/`) | ✅ Included | favicon.svg, opengraph.jpg, robots.txt |
| Hidden config files (`.env.example`, `.replit`) | ✅ Included | Real secrets excluded |

---

## 2. Frontend Pages Inventory

### User Portal (`/app`)
| Page | Route | Status |
|---|---|---|
| Dashboard | `/app` | ✅ |
| Browse Campaigns | `/app/campaigns` | ✅ |
| Campaign Detail & Share | `/app/campaigns/:id` | ✅ |
| Network Activation Gate | `/app/activate` | ✅ |
| Share History | `/app/share-history` | ✅ |
| Earnings | `/app/earnings` | ✅ |
| Payouts | `/app/payouts` | ✅ |
| Profile | `/app/profile` | ✅ |

### Business Portal (`/business`)
| Page | Route | Status |
|---|---|---|
| Onboarding | `/business/onboarding` | ✅ |
| Dashboard | `/business` | ✅ |
| Campaigns list | `/business/campaigns` | ✅ |
| New Campaign | `/business/campaigns/new` | ✅ |
| Campaign Analytics | `/business/campaigns/:id` | ✅ |
| Billing | `/business/billing` | ✅ |

### Admin Portal (`/admin`)
| Page | Route | Status |
|---|---|---|
| Platform Stats | `/admin` | ✅ |
| Users | `/admin/users` | ✅ |
| Businesses | `/admin/businesses` | ✅ |
| Campaigns | `/admin/campaigns` | ✅ |
| Rewards Queue | `/admin/rewards` | ✅ |
| Payout Requests | `/admin/payouts` | ✅ |
| Fraud Queue | `/admin/fraud` | ✅ |
| Audit Logs | `/admin/audit-logs` | ✅ |
| Settings | `/admin/settings` | ✅ |

### Public Pages
| Page | Route | Status |
|---|---|---|
| Landing | `/` | ✅ |
| How It Works | `/how-it-works` | ✅ |
| For Businesses | `/for-businesses` | ✅ |
| Pricing | `/pricing` | ✅ |
| Legal | `/legal` | ✅ |

---

## 3. Backend API Routes Inventory

| Route group | Path prefix | Status |
|---|---|---|
| Auth & profile | `/api/auth/*` | ✅ |
| User dashboard | `/api/dashboard/*` | ✅ |
| Network activation | `/api/network/*` | ✅ |
| User campaigns | `/api/campaigns/*` | ✅ |
| Share events | `/api/campaigns/:id/share` | ✅ |
| Rewards | `/api/rewards/*` | ✅ |
| Payouts | `/api/payouts/*` | ✅ |
| Business | `/api/business/*` | ✅ |
| Stripe webhooks | `/api/business/stripe/*` | ✅ |
| Admin | `/api/admin/*` | ✅ |
| Categories | `/api/categories` | ✅ |
| Health check | `/api/healthz` | ✅ |

---

## 4. Database & Data Sources

| Data source | Purpose | Export included | Restore method |
|---|---|---|---|
| PostgreSQL (all tables) | All application data | ✅ `handover/schema.sql` + `handover/seed_data.sql` | `psql $DATABASE_URL < handover/seed_data.sql` |
| Clerk (user auth) | Authentication identities & passwords | ⚠️ Partial — Clerk CSV export only | See Step 6 of RELAUNCH_GUIDE.md |
| Stripe (payments) | Subscription/payment history | ⚠️ Dashboard only — cannot bulk-import | Customers must re-subscribe on new account |
| Uploaded files / media | N/A — v1 has no file uploads | N/A | N/A |
| Object storage | Not used in v1 | N/A | N/A |

### Database Tables

| Table | Purpose |
|---|---|
| `users` | Platform user profiles, roles, earnings totals |
| `businesses` | Business accounts and approval status |
| `campaigns` | Business advertising campaigns |
| `categories` | Business category taxonomy (12 rows, seeded) |
| `share_events` | Every share action by users |
| `rewards` | Reward records linked to share events |
| `payout_requests` | User payout requests and status |
| `network_properties` | Network activation property tasks (5 rows, seeded) |
| `network_shares` | Completed network activation shares |
| `fraud_reviews` | Fraud flag records |
| `audit_logs` | Admin action audit trail |
| `platform_settings` | Key-value platform configuration |

---

## 5. Secrets & Environment Variables

| Variable | Status | Source |
|---|---|---|
| `DATABASE_URL` | ✅ Listed in `.env.example` | Your PostgreSQL host |
| `SESSION_SECRET` | ✅ Listed in `.env.example` | Generate randomly |
| `CLERK_SECRET_KEY` | ✅ Listed in `.env.example` | Clerk dashboard |
| `VITE_CLERK_PUBLISHABLE_KEY` | ✅ Listed in `.env.example` | Clerk dashboard |
| `STRIPE_SECRET_KEY` | ✅ Listed in `.env.example` | Stripe dashboard |
| `STRIPE_WEBHOOK_SECRET` | ✅ Listed in `.env.example` | Stripe dashboard |
| `STRIPE_PRICE_ID` | ✅ Listed in `.env.example` | Stripe dashboard |
| `PORT` | ✅ Listed in `.env.example` | Default: 5000 |
| `NODE_ENV` | ✅ Listed in `.env.example` | production |
| `APP_BASE_URL` | ✅ Listed in `.env.example` | Your domain |

**No real credentials are present anywhere in the source code or documentation.**

---

## 6. Integrations Documented

| Integration | Documented | Credential rotation steps |
|---|---|---|
| Clerk (auth) | ✅ `INTEGRATIONS_AND_SECRETS.md` §2 | ✅ |
| Stripe (payments) | ✅ `INTEGRATIONS_AND_SECRETS.md` §3 | ✅ |
| PostgreSQL | ✅ `INTEGRATIONS_AND_SECRETS.md` §1 | ✅ |
| Custom domain / DNS | ✅ `INTEGRATIONS_AND_SECRETS.md` §6 | ✅ |

---

## 7. Known Limitations & Manual Steps

| Item | Type | Action required |
|---|---|---|
| **Clerk user accounts** | Cannot export passwords or session tokens | Users must re-authenticate on new Clerk app; reward balances in DB are preserved if `clerkId` matches |
| **Stripe customers** | Stripe customer objects belong to original Stripe account | New Stripe account = customers must re-subscribe; historical payment records stay in original Stripe dashboard |
| **Stripe subscription history** | Not in PostgreSQL — lives in Stripe only | Export manually from Stripe dashboard if needed for records |
| **Admin role bootstrapping** | First admin must be seeded by setting `ADMIN_CLERK_USER_IDS` env var | Set before first login on new deployment |
| **Fraud prevention scoring** | Logic is server-side; no ML model to migrate | No action required — rules are code-based |
| **Email notifications** | Not yet implemented in v1 | No action required — no email provider to migrate |
| **File uploads / media** | Not implemented in v1 | No action required |
| **Scheduled jobs / cron** | No scheduled jobs in v1 | No action required |

---

## 8. Can the App Be Relaunched from This Package Alone?

**Yes**, with the following manual steps:

1. Set up a new PostgreSQL database and set `DATABASE_URL`
2. Create a Clerk application and set `CLERK_SECRET_KEY` + `VITE_CLERK_PUBLISHABLE_KEY`
3. Create a Stripe account with the $10/week price and set Stripe vars
4. Run `pnpm install && pnpm --filter @workspace/db run push && pnpm --filter @workspace/scripts run seed`
5. Start both workflows (API server + frontend)
6. Bootstrap an admin user via `ADMIN_CLERK_USER_IDS`

**A new owner can relaunch this app without access to the original Replit workspace.**

---

## 9. Files in This Handover Package

| File / Folder | Purpose |
|---|---|
| `earntree-handover.zip` | Complete source code archive |
| `.env.example` | All required environment variable names with placeholder values |
| `INTEGRATIONS_AND_SECRETS.md` | Every external service documented with credentials and rotation steps |
| `RELAUNCH_GUIDE.md` | Step-by-step relaunch instructions for any host |
| `HANDOVER_CHECKLIST.md` | This file — verification that the package is complete |
| `handover/schema.sql` | PostgreSQL DDL (table definitions) |
| `handover/seed_data.sql` | Current database data export |

---

## 10. Items That Replit Cannot Include in a Project Export

| Item | Reason | Action |
|---|---|---|
| **Environment secrets** | Replit secrets are never exposed in file exports | Re-enter all values from `.env.example` manually |
| **Replit deployment config** | Tied to the Replit account | Reconfigure via Replit Deployments panel |
| **Clerk authentication data** | Stored on Clerk's servers, not in this repo | Export from Clerk dashboard |
| **Stripe payment history** | Stored on Stripe's servers | Export from Stripe dashboard |
| **Database contents** | Stored on Replit's managed PostgreSQL | Included in `handover/seed_data.sql` |

---

*This checklist was generated on June 26, 2025. Verify all items before migrating to production.*
