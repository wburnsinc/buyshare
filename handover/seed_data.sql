--
-- PostgreSQL database dump
--

\restrict 1uTsKOc7Ccvf66tfKlZ7VcEWhlR2m0n8SAt0pTdz6PIcoM2wjVnVL5azZragCAG

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

--
-- Data for Name: admin_audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admin_audit_logs (id, admin_id, action, entity_type, entity_id, notes, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: businesses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.businesses (id, user_id, name, owner_name, email, phone, website, address, city, state, zip, category, bio, logo_url, service_radius, status, rejection_reason, stripe_customer_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: campaigns; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.campaigns (id, business_id, title, description, status, reward_amount, category, city, state, zip, service_radius, landing_page_url, cta_text, image_url, weekly_budget, budget_spent, estimated_verification_hours, start_date, end_date, target_audience, rejection_reason, share_count, click_count, conversion_count, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, slug, icon_name, sort_order, created_at) FROM stdin;
1	Restaurants & Food	restaurants	utensils	1	2026-06-25 19:32:51.482424+00
2	Health & Wellness	health	heart	2	2026-06-25 19:32:51.482424+00
3	Home Services	home-services	home	3	2026-06-25 19:32:51.482424+00
4	Beauty & Personal Care	beauty	sparkles	4	2026-06-25 19:32:51.482424+00
5	Fitness & Sports	fitness	dumbbell	5	2026-06-25 19:32:51.482424+00
6	Education & Tutoring	education	book	6	2026-06-25 19:32:51.482424+00
7	Auto & Transportation	auto	car	7	2026-06-25 19:32:51.482424+00
8	Pet Services	pets	paw-print	8	2026-06-25 19:32:51.482424+00
9	Professional Services	professional	briefcase	9	2026-06-25 19:32:51.482424+00
10	Entertainment & Events	entertainment	music	10	2026-06-25 19:32:51.482424+00
11	Retail & Shopping	retail	shopping-bag	11	2026-06-25 19:32:51.482424+00
12	Real Estate	real-estate	building	12	2026-06-25 19:32:51.482424+00
\.


--
-- Data for Name: click_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.click_events (id, tracking_link_id, user_id, ip_address, user_agent, referrer, is_self_click, is_duplicate, created_at) FROM stdin;
\.


--
-- Data for Name: fraud_reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fraud_reviews (id, user_id, share_event_id, type, risk_score, status, details, reviewed_by, created_at, reviewed_at) FROM stdin;
\.


--
-- Data for Name: network_properties; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.network_properties (id, property_name, property_url, description, logo_url, is_active, is_required, sort_order, created_at) FROM stdin;
1	EarnTree.co	https://earntree.co	Our main platform — share EarnTree with your network to activate your account and start earning.	\N	t	t	1	2026-06-25 19:32:51.50908+00
2	Buyshare.co	https://buyshare.co	A buying club for local deals — share with friends who love supporting local.	\N	t	t	2	2026-06-25 19:32:51.50908+00
3	Bluetruck.co	https://bluetruck.co	Local delivery and service connections — help your community discover reliable services.	\N	t	t	3	2026-06-25 19:32:51.50908+00
4	Pocketcash.co	https://pocketcash.co	Cash-back rewards for everyday spending — share to help neighbors save more.	\N	t	t	4	2026-06-25 19:32:51.50908+00
5	Burncall.co	https://burncall.co	Local business calling card — connect businesses with their ideal local customers.	\N	t	t	5	2026-06-25 19:32:51.50908+00
\.


--
-- Data for Name: network_tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.network_tasks (id, user_id, property_id, tracking_code, share_channel, is_completed, completed_at, click_count, created_at) FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, user_id, type, title, message, is_read, created_at) FROM stdin;
\.


--
-- Data for Name: payout_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payout_requests (id, user_id, amount, method, status, notes, stripe_payout_id, processed_by, created_at, processed_at) FROM stdin;
\.


--
-- Data for Name: platform_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.platform_settings (id, key, value, description, updated_at) FROM stdin;
1	rewardPerShare	0.25	USD reward per verified share	2026-06-25 19:32:51.520487+00
2	payoutThreshold	100	Minimum balance to request payout	2026-06-25 19:32:51.532128+00
3	dailyEarningCap	25	Max earnings per user per day	2026-06-25 19:32:51.53852+00
4	weeklyEarningCap	100	Max earnings per user per week	2026-06-25 19:32:51.544629+00
5	subscriptionWeeklyPrice	10	Business subscription weekly price USD	2026-06-25 19:32:51.550878+00
6	networkActivationRequired	true	Require network activation before earning	2026-06-25 19:32:51.558+00
7	networkActivationOptional	false	Allow users to skip network activation	2026-06-25 19:32:51.565451+00
8	fraudReviewThreshold	75	Fraud score threshold for auto-review flag	2026-06-25 19:32:51.572217+00
\.


--
-- Data for Name: reward_ledger; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reward_ledger (id, user_id, reward_id, payout_id, type, amount, balance_after, description, created_at) FROM stdin;
\.


--
-- Data for Name: rewards; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.rewards (id, user_id, campaign_id, share_event_id, amount, status, rejection_reason, reviewed_by, created_at, approved_at, paid_at) FROM stdin;
\.


--
-- Data for Name: share_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.share_events (id, user_id, campaign_id, network_task_id, tracking_link_id, share_channel, status, reward_status, fraud_score, ip_address, user_agent, created_at, verified_at) FROM stdin;
\.


--
-- Data for Name: subscriptions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.subscriptions (id, business_id, stripe_subscription_id, status, weekly_amount, current_period_end, cancel_at_period_end, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: tracking_links; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tracking_links (id, user_id, campaign_id, network_task_id, code, destination_url, click_count, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, clerk_id, email, name, avatar_url, role, referral_code, city, state, zip, lat, lng, network_activated, is_frozen, freeze_reason, available_balance, pending_balance, lifetime_earnings, created_at, updated_at) FROM stdin;
\.


--
-- Name: admin_audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.admin_audit_logs_id_seq', 1, false);


--
-- Name: businesses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.businesses_id_seq', 1, false);


--
-- Name: campaigns_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.campaigns_id_seq', 1, false);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 12, true);


--
-- Name: click_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.click_events_id_seq', 1, false);


--
-- Name: fraud_reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fraud_reviews_id_seq', 1, false);


--
-- Name: network_properties_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.network_properties_id_seq', 5, true);


--
-- Name: network_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.network_tasks_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: payout_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payout_requests_id_seq', 1, false);


--
-- Name: platform_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.platform_settings_id_seq', 8, true);


--
-- Name: reward_ledger_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reward_ledger_id_seq', 1, false);


--
-- Name: rewards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.rewards_id_seq', 1, false);


--
-- Name: share_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.share_events_id_seq', 1, false);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.subscriptions_id_seq', 1, false);


--
-- Name: tracking_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tracking_links_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- PostgreSQL database dump complete
--

\unrestrict 1uTsKOc7Ccvf66tfKlZ7VcEWhlR2m0n8SAt0pTdz6PIcoM2wjVnVL5azZragCAG

