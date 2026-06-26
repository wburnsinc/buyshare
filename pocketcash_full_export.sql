--
-- PostgreSQL database dump
--

\restrict guzycEyBxbKG9l582d7HfrGl3PgyGmzMvshELxWmhwlOgbPGltxab6udiWtBxgZ

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.activity (
    id integer NOT NULL,
    user_id text NOT NULL,
    type text NOT NULL,
    amount numeric(12,2),
    description text NOT NULL,
    counterparty_name text,
    campaign_title text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.activity_id_seq OWNED BY public.activity.id;


--
-- Name: campaigns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.campaigns (
    id integer NOT NULL,
    user_id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'loan'::text NOT NULL,
    goal_amount numeric(12,2) NOT NULL,
    raised_amount numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    min_contribution numeric(12,2) DEFAULT '1'::numeric NOT NULL,
    max_contribution numeric(12,2),
    interest_rate numeric(5,2),
    repayment_schedule text,
    duration_days integer DEFAULT 30 NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    supporter_count integer DEFAULT 0 NOT NULL,
    share_count integer DEFAULT 0 NOT NULL,
    image_url text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: campaigns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.campaigns_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: campaigns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.campaigns_id_seq OWNED BY public.campaigns.id;


--
-- Name: contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.contributions (
    id integer NOT NULL,
    campaign_id integer NOT NULL,
    user_id text NOT NULL,
    amount numeric(12,2) NOT NULL,
    type text DEFAULT 'lender_funding'::text NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    platform_fee numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    processing_fee numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    stripe_payment_intent_id text,
    deal_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: contributions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.contributions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.contributions_id_seq OWNED BY public.contributions.id;


--
-- Name: deals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deals (
    id integer NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    type text DEFAULT 'loan'::text NOT NULL,
    min_amount numeric(12,2) NOT NULL,
    max_amount numeric(12,2) NOT NULL,
    interest_rate numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    repayment_schedule text DEFAULT 'monthly'::text NOT NULL,
    duration_days integer DEFAULT 30 NOT NULL,
    is_popular boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: deals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.deals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.deals_id_seq OWNED BY public.deals.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorites (
    id integer NOT NULL,
    user_id text NOT NULL,
    lender_id text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: fee_config; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fee_config (
    id integer NOT NULL,
    processing_fee_amount numeric(10,2) DEFAULT 1.00 NOT NULL,
    processing_fee_label text DEFAULT 'PocketCash Processing Fee'::text NOT NULL,
    platform_fee_percent numeric(5,2) DEFAULT 2.5 NOT NULL,
    stripe_mode text DEFAULT 'test'::text NOT NULL,
    stripe_enabled boolean DEFAULT false NOT NULL,
    processing_fee_eligible_types text[] DEFAULT '{lender_funding,community_support}'::text[] NOT NULL,
    platform_fee_eligible_types text[] DEFAULT '{lender_funding,community_support,repayment}'::text[] NOT NULL,
    processing_fee_refundable boolean DEFAULT false NOT NULL,
    emergency_kill_switch boolean DEFAULT false NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: fee_config_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fee_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fee_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fee_config_id_seq OWNED BY public.fee_config.id;


--
-- Name: loans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.loans (
    id integer NOT NULL,
    campaign_id integer,
    borrower_id text NOT NULL,
    lender_id text,
    principal_amount numeric(12,2) NOT NULL,
    interest_rate numeric(5,2) DEFAULT '0'::numeric NOT NULL,
    repayment_schedule text DEFAULT 'monthly'::text NOT NULL,
    total_repay_amount numeric(12,2) NOT NULL,
    amount_repaid numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    due_date text NOT NULL,
    deal_id integer,
    is_repeat boolean DEFAULT false NOT NULL,
    repayment_count integer DEFAULT 0 NOT NULL,
    next_payment_date text,
    next_payment_amount numeric(12,2),
    autopay_enabled boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: loans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.loans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.loans_id_seq OWNED BY public.loans.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id text NOT NULL,
    type text NOT NULL,
    title text NOT NULL,
    body text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    reference_id text,
    reference_type text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: partnerships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.partnerships (
    id integer NOT NULL,
    initiator_id text NOT NULL,
    partner_id text NOT NULL,
    campaign_id integer,
    status text DEFAULT 'pending'::text NOT NULL,
    initiator_share_percent numeric(5,2) DEFAULT '50'::numeric NOT NULL,
    partner_share_percent numeric(5,2) DEFAULT '50'::numeric NOT NULL,
    total_invested numeric(14,2) DEFAULT '0'::numeric NOT NULL,
    total_earned numeric(14,2) DEFAULT '0'::numeric NOT NULL,
    message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: partnerships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.partnerships_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: partnerships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.partnerships_id_seq OWNED BY public.partnerships.id;


--
-- Name: pocket_pool; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pocket_pool (
    id integer NOT NULL,
    total_balance numeric(14,2) DEFAULT '0'::numeric NOT NULL,
    total_contributors integer DEFAULT 0 NOT NULL,
    total_rewards_distributed numeric(14,2) DEFAULT '0'::numeric NOT NULL,
    yearly_reward_rate_percent numeric(5,2) DEFAULT '5'::numeric NOT NULL,
    contribution_amount numeric(10,2) DEFAULT '3'::numeric NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description text DEFAULT 'Contribute to the PocketCash community pool and earn yearly rewards while funding the platform.'::text NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: pocket_pool_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pocket_pool_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pocket_pool_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pocket_pool_id_seq OWNED BY public.pocket_pool.id;


--
-- Name: pool_contributions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_contributions (
    id integer NOT NULL,
    user_id text NOT NULL,
    amount numeric(10,2) NOT NULL,
    status text DEFAULT 'active'::text NOT NULL,
    yearly_reward_rate numeric(5,2) DEFAULT '5'::numeric NOT NULL,
    total_reward_earned numeric(10,2) DEFAULT '0'::numeric NOT NULL,
    last_reward_paid_at timestamp with time zone,
    stripe_payment_intent_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: pool_contributions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_contributions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pool_contributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_contributions_id_seq OWNED BY public.pool_contributions.id;


--
-- Name: pool_rewards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pool_rewards (
    id integer NOT NULL,
    user_id text NOT NULL,
    contribution_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    year integer NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    paid_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: pool_rewards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pool_rewards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pool_rewards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pool_rewards_id_seq OWNED BY public.pool_rewards.id;


--
-- Name: repayments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repayments (
    id integer NOT NULL,
    loan_id integer NOT NULL,
    user_id text NOT NULL,
    amount numeric(12,2) NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    scheduled_date text NOT NULL,
    paid_date text,
    stripe_payment_intent_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: repayments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.repayments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repayments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.repayments_id_seq OWNED BY public.repayments.id;


--
-- Name: social_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.social_shares (
    id integer NOT NULL,
    user_id text NOT NULL,
    platform text NOT NULL,
    share_type text NOT NULL,
    campaign_id integer,
    share_url text NOT NULL,
    message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: social_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.social_shares_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: social_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.social_shares_id_seq OWNED BY public.social_shares.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    user_id text NOT NULL,
    counterparty_id text,
    type text NOT NULL,
    amount numeric(12,2) NOT NULL,
    platform_fee numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    processing_fee numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    net_amount numeric(12,2) NOT NULL,
    status text DEFAULT 'pending'::text NOT NULL,
    description text NOT NULL,
    stripe_payment_intent_id text,
    reference_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    clerk_id text NOT NULL,
    email text NOT NULL,
    first_name text,
    last_name text,
    avatar_url text,
    role text DEFAULT 'borrower'::text NOT NULL,
    bio text,
    is_verified boolean DEFAULT false NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    total_lent numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    total_borrowed numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    total_repaid numeric(12,2) DEFAULT '0'::numeric NOT NULL,
    credit_score integer,
    connected_platforms text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    occupation text,
    annual_earnings numeric(14,2),
    is_earnings_public boolean DEFAULT false NOT NULL,
    pool_contributor boolean DEFAULT false NOT NULL,
    partner_count integer DEFAULT 0 NOT NULL
);


--
-- Name: activity id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity ALTER COLUMN id SET DEFAULT nextval('public.activity_id_seq'::regclass);


--
-- Name: campaigns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns ALTER COLUMN id SET DEFAULT nextval('public.campaigns_id_seq'::regclass);


--
-- Name: contributions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributions ALTER COLUMN id SET DEFAULT nextval('public.contributions_id_seq'::regclass);


--
-- Name: deals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deals ALTER COLUMN id SET DEFAULT nextval('public.deals_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: fee_config id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_config ALTER COLUMN id SET DEFAULT nextval('public.fee_config_id_seq'::regclass);


--
-- Name: loans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans ALTER COLUMN id SET DEFAULT nextval('public.loans_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: partnerships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships ALTER COLUMN id SET DEFAULT nextval('public.partnerships_id_seq'::regclass);


--
-- Name: pocket_pool id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pocket_pool ALTER COLUMN id SET DEFAULT nextval('public.pocket_pool_id_seq'::regclass);


--
-- Name: pool_contributions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_contributions ALTER COLUMN id SET DEFAULT nextval('public.pool_contributions_id_seq'::regclass);


--
-- Name: pool_rewards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_rewards ALTER COLUMN id SET DEFAULT nextval('public.pool_rewards_id_seq'::regclass);


--
-- Name: repayments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayments ALTER COLUMN id SET DEFAULT nextval('public.repayments_id_seq'::regclass);


--
-- Name: social_shares id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_shares ALTER COLUMN id SET DEFAULT nextval('public.social_shares_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.activity (id, user_id, type, amount, description, counterparty_name, campaign_title, reference_id, created_at) FROM stdin;
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campaigns (id, user_id, title, description, type, goal_amount, raised_amount, min_contribution, max_contribution, interest_rate, repayment_schedule, duration_days, status, supporter_count, share_count, image_url, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: contributions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.contributions (id, campaign_id, user_id, amount, type, status, platform_fee, processing_fee, stripe_payment_intent_id, deal_id, created_at) FROM stdin;
\.


--
-- Data for Name: deals; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.deals (id, name, description, type, min_amount, max_amount, interest_rate, repayment_schedule, duration_days, is_popular, created_at) FROM stdin;
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.favorites (id, user_id, lender_id, created_at) FROM stdin;
\.


--
-- Data for Name: fee_config; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fee_config (id, processing_fee_amount, processing_fee_label, platform_fee_percent, stripe_mode, stripe_enabled, processing_fee_eligible_types, platform_fee_eligible_types, processing_fee_refundable, emergency_kill_switch, updated_at) FROM stdin;
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.loans (id, campaign_id, borrower_id, lender_id, principal_amount, interest_rate, repayment_schedule, total_repay_amount, amount_repaid, status, due_date, deal_id, is_repeat, repayment_count, next_payment_date, next_payment_amount, autopay_enabled, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, type, title, body, is_read, reference_id, reference_type, created_at) FROM stdin;
\.


--
-- Data for Name: partnerships; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.partnerships (id, initiator_id, partner_id, campaign_id, status, initiator_share_percent, partner_share_percent, total_invested, total_earned, message, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: pocket_pool; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pocket_pool (id, total_balance, total_contributors, total_rewards_distributed, yearly_reward_rate_percent, contribution_amount, is_active, description, updated_at) FROM stdin;
\.


--
-- Data for Name: pool_contributions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pool_contributions (id, user_id, amount, status, yearly_reward_rate, total_reward_earned, last_reward_paid_at, stripe_payment_intent_id, created_at) FROM stdin;
\.


--
-- Data for Name: pool_rewards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pool_rewards (id, user_id, contribution_id, amount, year, status, paid_at, created_at) FROM stdin;
\.


--
-- Data for Name: repayments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.repayments (id, loan_id, user_id, amount, status, scheduled_date, paid_date, stripe_payment_intent_id, created_at) FROM stdin;
\.


--
-- Data for Name: social_shares; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.social_shares (id, user_id, platform, share_type, campaign_id, share_url, message, created_at) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.transactions (id, user_id, counterparty_id, type, amount, platform_fee, processing_fee, net_amount, status, description, stripe_payment_intent_id, reference_id, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, clerk_id, email, first_name, last_name, avatar_url, role, bio, is_verified, is_admin, total_lent, total_borrowed, total_repaid, credit_score, connected_platforms, created_at, updated_at, occupation, annual_earnings, is_earnings_public, pool_contributor, partner_count) FROM stdin;
\.


--
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.activity_id_seq', 1, false);


--
-- Name: campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campaigns_id_seq', 1, false);


--
-- Name: contributions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.contributions_id_seq', 1, false);


--
-- Name: deals_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.deals_id_seq', 1, false);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.favorites_id_seq', 1, false);


--
-- Name: fee_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fee_config_id_seq', 1, false);


--
-- Name: loans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.loans_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: partnerships_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.partnerships_id_seq', 1, false);


--
-- Name: pocket_pool_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pocket_pool_id_seq', 1, false);


--
-- Name: pool_contributions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pool_contributions_id_seq', 1, false);


--
-- Name: pool_rewards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pool_rewards_id_seq', 1, false);


--
-- Name: repayments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.repayments_id_seq', 1, false);


--
-- Name: social_shares_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.social_shares_id_seq', 1, false);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.transactions_id_seq', 1, false);


--
-- Name: activity activity_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.activity
    ADD CONSTRAINT activity_pkey PRIMARY KEY (id);


--
-- Name: campaigns campaigns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.campaigns
    ADD CONSTRAINT campaigns_pkey PRIMARY KEY (id);


--
-- Name: contributions contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.contributions
    ADD CONSTRAINT contributions_pkey PRIMARY KEY (id);


--
-- Name: deals deals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deals
    ADD CONSTRAINT deals_pkey PRIMARY KEY (id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: fee_config fee_config_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fee_config
    ADD CONSTRAINT fee_config_pkey PRIMARY KEY (id);


--
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: partnerships partnerships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.partnerships
    ADD CONSTRAINT partnerships_pkey PRIMARY KEY (id);


--
-- Name: pocket_pool pocket_pool_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pocket_pool
    ADD CONSTRAINT pocket_pool_pkey PRIMARY KEY (id);


--
-- Name: pool_contributions pool_contributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_contributions
    ADD CONSTRAINT pool_contributions_pkey PRIMARY KEY (id);


--
-- Name: pool_rewards pool_rewards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pool_rewards
    ADD CONSTRAINT pool_rewards_pkey PRIMARY KEY (id);


--
-- Name: repayments repayments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repayments
    ADD CONSTRAINT repayments_pkey PRIMARY KEY (id);


--
-- Name: social_shares social_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.social_shares
    ADD CONSTRAINT social_shares_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_clerk_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_clerk_id_unique UNIQUE (clerk_id);


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_unique UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- PostgreSQL database dump complete
--

\unrestrict guzycEyBxbKG9l582d7HfrGl3PgyGmzMvshELxWmhwlOgbPGltxab6udiWtBxgZ

