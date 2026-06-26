# PocketCash

A full-stack peer-to-peer lending, borrowing, and community support platform. Neighbors lend to neighbors, communities fund each other, and money moves with transparency.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 8080)
- `pnpm --filter @workspace/pocketcash run dev` — run the frontend (auto-assigned port)
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- Frontend: React + Vite, Tailwind v4, shadcn/ui, wouter routing, framer-motion, recharts, lucide-react
- Auth: Clerk (Google SSO + Gmail) — cookie-based for web
- API: Express 5 with Clerk middleware
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec in `lib/api-spec/openapi.yaml`)
- Build: esbuild (CJS bundle)

## Where things live

- `lib/api-spec/openapi.yaml` — source of truth for all API contracts
- `lib/db/src/schema/` — all Drizzle schema files (users, campaigns, contributions, loans, repayments, transactions, deals, favorites, activity, fee_config, social_shares)
- `lib/api-client-react/src/generated/` — Orval-generated hooks (DO NOT EDIT manually)
- `artifacts/api-server/src/routes/` — Express route handlers
- `artifacts/pocketcash/src/pages/` — React page components
- `artifacts/pocketcash/src/components/layout/AppLayout.tsx` — main authenticated layout with sidebar

## Architecture decisions

- Contract-first API: OpenAPI spec drives codegen for both server validation and client hooks. Run `pnpm --filter @workspace/api-spec run codegen` after any spec change.
- Clerk auth is cookie-based for web — never add `Authorization: Bearer` headers or `getToken()` to browser API calls.
- Fees: 2.5% platform fee + $1.00 PocketCash Processing Fee, configurable via admin portal. Emergency kill switch supported.
- Stripe is in demo mode — no real credentials needed for MVP. Mock payment intents are returned.
- AI matching uses heuristic scoring (no external AI API required) — returns scored lender/borrower matches.

## Product

- **Campaigns**: Loan requests and community support fundraisers with progress tracking
- **Lending/Borrowing**: Direct P2P loans with flexible repayment schedules (All at Once, Weekly, Biweekly, Monthly, 3 Months, 6 Months)
- **Deals**: Predetermined deal templates for quick lending
- **AI Matching**: Score-based lender-borrower matching with deal suggestions
- **Social Sharing**: Share campaigns and milestones to Twitter/X, Facebook, LinkedIn, Instagram, WhatsApp
- **Favorites**: Bookmark lenders for future campaigns
- **Admin Portal**: Fee config, platform stats, user management, emergency kill switch
- **Payments**: Fee breakdown checkout (amount + 2.5% platform fee + $1 processing fee)

## User preferences

- No emojis in UI
- Bold, navy/teal primary colors with green accents
- Dense, information-rich financial cockpit aesthetic
- data-testid attributes on interactive elements

## Gotchas

- Clerk: `publishableKey` must use `publishableKeyFromHost()` from `@clerk/react/internal` — never the raw env var
- Clerk: `proxyUrl` is always set unconditionally — do not gate on NODE_ENV
- Tailwind v4: `@layer theme, base, clerk, components, utilities;` must be first line in `index.css`
- Tailwind v4: `tailwindcss({ optimize: false })` in vite.config.ts prevents Clerk theme breakage in prod
- DB push: always run `pnpm --filter @workspace/db run push` after schema changes
- Orval hooks: params go as first arg, `{ query: {...} }` options as second arg — e.g. `useListCampaigns(params, { query: {...} })`
- `useListFavorites` takes only an options object (no params first arg)
- `SiLinkedin` does not exist in react-icons v5 si — use `Linkedin` from lucide-react
- Never use `console.log` in server code — use `req.log` in routes and `logger` elsewhere

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
- See the `clerk-auth` skill for Clerk wiring rules
