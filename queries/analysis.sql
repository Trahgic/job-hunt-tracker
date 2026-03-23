-- ============================================================
-- job hunt tracker: analytical queries
-- each query answers a real question you'd want to know
-- during a job search
-- ============================================================


-- 1. pipeline overview: where do all my applications stand?
-- demonstrates: GROUP BY, COUNT, percentage calculation
SELECT
    status,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct
FROM applications
GROUP BY status
ORDER BY total DESC;


-- 2. which referral sources actually lead to interviews?
-- demonstrates: LEFT JOIN, CASE, conditional aggregation
SELECT
    rs.name AS source,
    COUNT(DISTINCT a.id) AS applications,
    COUNT(DISTINCT CASE WHEN i.id IS NOT NULL THEN a.id END) AS got_interviews,
    ROUND(
        COUNT(DISTINCT CASE WHEN i.id IS NOT NULL THEN a.id END) * 100.0
        / NULLIF(COUNT(DISTINCT a.id), 0), 1
    ) AS interview_rate_pct
FROM referral_sources rs
JOIN applications a ON a.source_id = rs.id
LEFT JOIN interviews i ON i.application_id = a.id
GROUP BY rs.name
ORDER BY interview_rate_pct DESC;


-- 3. average days to first response by company size
-- demonstrates: JOIN, AVG, date arithmetic, filtering NULLs
SELECT
    c.company_size,
    COUNT(*) AS apps_with_response,
    ROUND(AVG(a.response_date - a.applied_date), 1) AS avg_days_to_respond
FROM applications a
JOIN companies c ON c.id = a.company_id
WHERE a.response_date IS NOT NULL
GROUP BY c.company_size
ORDER BY avg_days_to_respond;


-- 4. full application timeline: every app with its interview count and current status
-- demonstrates: CTE, LEFT JOIN, subquery aggregation
WITH interview_counts AS (
    SELECT
        application_id,
        COUNT(*) AS rounds_completed,
        MAX(round_number) AS furthest_round
    FROM interviews
    GROUP BY application_id
)
SELECT
    c.name AS company,
    a.position_title,
    a.status,
    a.applied_date,
    a.response_date,
    COALESCE(ic.rounds_completed, 0) AS interview_rounds,
    COALESCE(ic.furthest_round, 0) AS furthest_round,
    a.excitement_level,
    a.salary_min || 'k - ' || a.salary_max || 'k' AS salary_range
FROM applications a
JOIN companies c ON c.id = a.company_id
LEFT JOIN interview_counts ic ON ic.application_id = a.id
ORDER BY a.applied_date;


-- 5. ghosted vs rejected: how long did I wait before giving up?
-- demonstrates: CASE, date math, filtered aggregation
SELECT
    status,
    COUNT(*) AS total,
    ROUND(AVG(closed_date - applied_date), 1) AS avg_days_until_closed,
    MIN(closed_date - applied_date) AS fastest_close,
    MAX(closed_date - applied_date) AS slowest_close
FROM applications
WHERE status IN ('ghosted', 'rejected')
GROUP BY status;


-- 6. follow-up effectiveness: do thank-you emails get responses?
-- demonstrates: GROUP BY, conditional aggregation, boolean analysis
SELECT
    follow_up_type,
    method,
    COUNT(*) AS total_sent,
    SUM(CASE WHEN got_response THEN 1 ELSE 0 END) AS got_reply,
    ROUND(
        SUM(CASE WHEN got_response THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1
    ) AS response_rate_pct
FROM follow_ups
GROUP BY follow_up_type, method
ORDER BY response_rate_pct DESC;


-- 7. weekly application volume: am I slowing down or ramping up?
-- demonstrates: DATE_TRUNC, window function (running total)
SELECT
    DATE_TRUNC('week', applied_date)::DATE AS week_starting,
    COUNT(*) AS apps_this_week,
    SUM(COUNT(*)) OVER (ORDER BY DATE_TRUNC('week', applied_date)) AS running_total
FROM applications
GROUP BY DATE_TRUNC('week', applied_date)
ORDER BY week_starting;


-- 8. salary range analysis by remote policy
-- demonstrates: aggregation, ROUND, AVG on ranges
SELECT
    remote_policy,
    COUNT(*) AS positions,
    ROUND(AVG(salary_min)) AS avg_floor,
    ROUND(AVG(salary_max)) AS avg_ceiling,
    ROUND(AVG((salary_min + salary_max) / 2.0)) AS avg_midpoint
FROM applications
GROUP BY remote_policy
ORDER BY avg_midpoint DESC;


-- 9. companies I've applied to multiple times
-- demonstrates: HAVING, GROUP BY, string aggregation
SELECT
    c.name AS company,
    COUNT(*) AS times_applied,
    STRING_AGG(a.position_title, ', ' ORDER BY a.applied_date) AS roles_applied_for,
    STRING_AGG(a.status, ', ' ORDER BY a.applied_date) AS statuses
FROM applications a
JOIN companies c ON c.id = a.company_id
GROUP BY c.name
HAVING COUNT(*) > 1
ORDER BY times_applied DESC;


-- 10. interview success funnel: how many apps make it to each stage?
-- demonstrates: CTE, CASE, funnel analysis
WITH stages AS (
    SELECT
        a.id,
        a.status,
        COALESCE(MAX(i.round_number), 0) AS max_round
    FROM applications a
    LEFT JOIN interviews i ON i.application_id = a.id
    GROUP BY a.id, a.status
)
SELECT
    COUNT(*) AS total_applications,
    SUM(CASE WHEN max_round >= 1 THEN 1 ELSE 0 END) AS reached_phone_screen,
    SUM(CASE WHEN max_round >= 2 THEN 1 ELSE 0 END) AS reached_round_2,
    SUM(CASE WHEN max_round >= 3 THEN 1 ELSE 0 END) AS reached_round_3,
    SUM(CASE WHEN max_round >= 4 THEN 1 ELSE 0 END) AS reached_final_round,
    SUM(CASE WHEN status = 'offer' THEN 1 ELSE 0 END) AS got_offer
FROM stages;


-- 11. contact network: who do I know and where?
-- demonstrates: multiple JOINs, COALESCE, LEFT JOIN
SELECT
    c.name AS company,
    ct.name AS contact_name,
    ct.relationship,
    ct.role,
    COALESCE(a.position_title, '(no application yet)') AS related_application,
    COALESCE(a.status, '-') AS app_status
FROM contacts ct
JOIN companies c ON c.id = ct.company_id
LEFT JOIN applications a ON a.id = ct.application_id
ORDER BY c.name, ct.relationship;


-- 12. best day of week to apply (just for fun, shows date functions)
-- demonstrates: EXTRACT, day-of-week analysis
SELECT
    TO_CHAR(applied_date, 'Day') AS day_of_week,
    EXTRACT(DOW FROM applied_date) AS day_num,
    COUNT(*) AS applications,
    ROUND(
        SUM(CASE WHEN status IN ('interviewing', 'offer', 'phone_screen') THEN 1 ELSE 0 END) * 100.0
        / COUNT(*), 1
    ) AS positive_outcome_pct
FROM applications
GROUP BY TO_CHAR(applied_date, 'Day'), EXTRACT(DOW FROM applied_date)
ORDER BY day_num;