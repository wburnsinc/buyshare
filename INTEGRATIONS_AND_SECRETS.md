# PocketCash — Integrations & Secrets

## 1. Clerk (Authentication)

**Purpose:** User authentication (Google SSO, email/password), session management, JWT issuance.

**Environment variables:**
| Variable | Description |
|---|---|
| `CLERK_SECRET_KEY` | Server-side secret key for verifying sessions |
| `CLERK_PUBLISHABLE_KEY` | Server-side publishable key |
| `VITE_CLERK_PUBLISHABLE_KEY` | Client-side publishable key (same value) |
| `VITE_CLERK_PROXY_URL` | Leave empty in development; Replit auto-sets in production |

**How to obtain:** Create an app at https://dashboard.clerk.com → API Keys tab.

**After migration:**
1. Create a new Clerk application at dashboard.clerk.com.
2. Enable Google OAuth provider under "Social Connections."
3. Set the application name to "PocketCash."
4. Copy the new keys into your environment.
5. Update the allowed redirect URLs to match your new domain.
6. Add the new domain to "Allowed Origins" in Clerk dashboard.

**Note:** Replit-managed Clerk provisions a shared tenant — after migration you must create your own Clerk account.

---

## 2. PostgreSQL (Database)

**Purpose:** Primary data store for all application data (users, campaigns, loans, contributions, transactions, etc.).

**Environment variables:**
| Variable | Description |
|---|---|
| `DATABASE_URL` | Full connection string |
| `PGHOST` | Host |
| `PGPORT` | Port (default: 5432) |
| `PGUSER` | Username |
| `PGPASSWORD` | Password |
| `PGDATABASE` | Database name |

**How to obtain:** Create a PostgreSQL database on Neon, Supabase, Railway, or any hosted provider. Or run `pg` locally.

**After migration:** Run `pnpm --filter @workspace/db run push` to apply the schema.

---

## 3. Stripe (Payments — Demo Mode)

**Purpose:** Payment processing for contributions, loan repayments, and pool contributions. Currently in demo/test mode — no real money moves.

**Environment variables:**
| Variable | Description |
|---|---|
| `STRIPE_SECRET_KEY` | Server-side secret key |
| `VITE_STRIPE_PUBLISHABLE_KEY` | Client-side publishable key |

**How to obtain:** Create account at https://stripe.com → Developers → API Keys.

**After migration:**
1. Create a Stripe account.
2. Use test keys (`sk_test_...`) for development.
3. Switch to live keys (`sk_live_...`) for production.
4. Set up webhooks for payment events at `/api/payments/webhook`.

---

## 4. Session Secret

**Purpose:** Signs and verifies HTTP session cookies.

**Environment variable:** `SESSION_SECRET`

**How to generate:** Run `openssl rand -base64 48` and use the output.

---

## Known Limitations

- **Clerk tenant:** If hosted on Replit, Clerk is provisioned by Replit. You must create your own Clerk account after migration.
- **Stripe:** Currently in demo mode. Real Stripe integration requires setting up webhooks and configuring production keys.
- **No email provider:** PocketCash does not currently send email (planned feature). Add SendGrid or Resend to enable email notifications.
- **No object storage:** User avatars use URL references only. Media uploads would require S3 or similar.
