-- ============================================================
-- reusable views: common joins you'd run all the time
-- ============================================================


-- full application details in one place — no more 4-table joins every time
CREATE OR REPLACE VIEW v_application_details AS
SELECT
    a.id AS application_id,
    c.name AS company,
    c.industry,
    c.company_size,
    c.glassdoor_rating,
    rs.name AS source,
    a.position_title,
    a.salary_min,
    a.salary_max,
    (a.salary_min / 1000) || 'k - ' || (a.salary_max / 1000) || 'k' AS salary_range,
    a.location,
    a.remote_policy,
    a.status,
    a.applied_date,
    a.response_date,
    a.closed_date,
    a.excitement_level,
    CASE
        WHEN a.response_date IS NOT NULL
        THEN a.response_date - a.applied_date
    END AS days_to_response,
    CASE
        WHEN a.closed_date IS NOT NULL
        THEN a.closed_date - a.applied_date
    END AS days_to_close,
    a.notes
FROM applications a
JOIN companies c ON c.id = a.company_id
LEFT JOIN referral_sources rs ON rs.id = a.source_id;


-- interview history with company and position context
CREATE OR REPLACE VIEW v_interview_history AS
SELECT
    i.id AS interview_id,
    c.name AS company,
    a.position_title,
    a.status AS application_status,
    i.round_number,
    i.interview_type,
    i.scheduled_at,
    i.duration_minutes,
    i.interviewer_name,
    i.interviewer_role,
    i.went_well,
    i.notes
FROM interviews i
JOIN applications a ON a.id = i.application_id
JOIN companies c ON c.id = a.company_id
ORDER BY i.scheduled_at;


-- contact directory with company and application context
CREATE OR REPLACE VIEW v_contacts AS
SELECT
    ct.id AS contact_id,
    c.name AS company,
    ct.name AS contact_name,
    ct.role,
    ct.email,
    ct.linkedin_url,
    ct.relationship,
    COALESCE(a.position_title, '(no application)') AS related_position,
    COALESCE(a.status, '-') AS application_status,
    ct.notes
FROM contacts ct
JOIN companies c ON c.id = ct.company_id
LEFT JOIN applications a ON a.id = ct.application_id;


-- follow-up log with contact and company info
CREATE OR REPLACE VIEW v_follow_up_log AS
SELECT
    f.id AS follow_up_id,
    c.name AS company,
    a.position_title,
    ct.name AS contact_name,
    f.follow_up_type,
    f.method,
    f.sent_at,
    f.content_summary,
    f.got_response
FROM follow_ups f
JOIN applications a ON a.id = f.application_id
JOIN companies c ON c.id = a.company_id
LEFT JOIN contacts ct ON ct.id = f.contact_id
ORDER BY f.sent_at;


-- pipeline summary: one row per status with counts and avg salary
CREATE OR REPLACE VIEW v_pipeline_summary AS
SELECT
    status,
    COUNT(*) AS total,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 1) AS pct,
    ROUND(AVG((salary_min + salary_max) / 2.0)) AS avg_midpoint_salary
FROM applications
GROUP BY status;
