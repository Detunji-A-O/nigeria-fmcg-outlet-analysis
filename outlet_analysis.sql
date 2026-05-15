-- ============================================================
-- Nigeria FMCG Outlet Distribution Intelligence
-- Author: Adetunji Adesibikan
-- Tool: DB Browser for SQLite
-- Dataset: Nigeria_Outlet_Universe_2024.db
--
-- Context: Synthetic dataset designed from 4 years of KAM
-- experience at Henkel AG Nigeria — a Fortune Global 500
-- company (Düsseldorf, Germany). 120 outlets across 6 states.
-- Answers field force prioritisation questions that FMCG
-- companies pay NielsenIQ to answer at enterprise scale.
-- ============================================================/* Q1: Revenue Concentration by Outlet Type - which channel drives the most revenue? */
SELECT	outlet_type,
		COUNT(*) AS outlet_count,
		SUM(monthly_sales_NGN) AS total_revenue,
		ROUND(SUM(monthly_sales_NGN)*100.0 /(SELECT SUM(monthly_sales_NGN) FROM Outlets), 1) AS pct_of_total
FROM	outlets
GROUP BY	outlet_type
ORDER BY	total_revenue DESC;


/*  Q2: Revenue per sales visit (visit efficiency) */

SELECT	outlet_type,
		territory,
		SUM(monthly_sales_NGN) AS total_revenue,
		SUM(visit_freq_per_month) AS total_visits,
		ROUND(SUM(monthly_sales_NGN) *1.0 /NULLIF(SUM(visit_freq_per_month), 0), 0) AS revenue_per_visit
FROM	Outlets
WHERE	outlet_active = 1
GROUP BY	outlet_type,
			territory
ORDER BY	revenue_per_visit DESC;


/* Q3: Dormant outlets by territory (recovery opportunity) */

SELECT	territory,
		COUNT(*) AS dormant_count,
		SUM (monthly_sales_NGN) AS recoverable_monthly_NGN
FROM	Outlets
WHERE	outlet_active = 0
GROUP BY	territory;


/* Q4: Top 20 outlets by monthly sales */

SELECT	outlet_name,
		outlet_type,
		state,
		monthly_sales_NGN,
		visit_freq_per_month
FROM	Outlets
WHERE	outlet_active = 1
ORDER BY	monthly_sales_NGN DESC
LIMIT	20;


/* Q5: High OOS + high sales = priority restocking targets */

SELECT	outlet_name,
		outlet_type,
		state,
		monthly_sales_NGN,
		oos_incidents_per_month
FROM	Outlets
WHERE	oos_incidents_per_month >= 3 AND monthly_sales_NGN > 500000
ORDER BY	monthly_sales_NGN DESC;