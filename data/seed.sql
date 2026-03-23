-- seed data: a realistic 3-month job search
-- mix of outcomes: ghosted, rejected, offers, still in progress

INSERT INTO referral_sources (name) VALUES
    ('LinkedIn'),
    ('Indeed'),
    ('Company Website'),
    ('Friend Referral'),
    ('Recruiter Outreach'),
    ('AngelList / Wellfound'),
    ('Hacker News'),
    ('Job Fair');


INSERT INTO companies (name, industry, company_size, careers_url, glassdoor_rating, notes) VALUES
    ('Datastream Labs',       'SaaS',           'startup',    'https://datastreamlabs.io/careers',   4.2, 'Series A, ~40 people. Cool product but early stage.'),
    ('Bolt Financial',        'Fintech',        'mid',        'https://boltfinancial.com/jobs',      3.8, 'Payments company. Heard mixed things about WLB.'),
    ('Meridian Health Tech',  'Healthcare',     'enterprise', 'https://meridianhealthtech.com/jobs',  3.5, 'Big corp vibes but stable and good benefits.'),
    ('Canopy Software',       'Developer Tools','startup',    'https://canopysoftware.dev/careers',  4.5, 'Small team, open source friendly. Dream company.'),
    ('Pinnacle Group',        'Consulting',     'enterprise', 'https://pinnaclegroup.com/careers',   3.2, 'Backup option. Not thrilling but pays well.'),
    ('NovaBridge AI',         'AI/ML',          'mid',        'https://novabridgeai.com/careers',    4.0, 'Doing interesting LLM stuff. Competitive to get into.'),
    ('Greenline Logistics',   'Logistics',      'mid',        'https://greenlinelogistics.com/jobs', 3.6, 'Remote-first which is a big plus.'),
    ('Apex Digital',          'E-commerce',     'startup',    'https://apexdigital.co/careers',      4.1, 'Fast growing. Recruiter reached out to me.'),
    ('Rivermount Partners',   'Finance',        'enterprise', 'https://rivermountpartners.com/jobs', 3.9, 'Boring industry but great comp package.'),
    ('Cloudpeak Systems',     'Cloud Infra',    'mid',        'https://cloudpeaksystems.io/careers', 4.3, 'Heard great things from a friend who works there.');


-- 15 applications across 10 companies, spread over ~3 months
INSERT INTO applications (company_id, source_id, position_title, job_url, salary_min, salary_max, location, remote_policy, status, applied_date, response_date, closed_date, excitement_level, notes) VALUES
    -- week 1-2: early spray and pray
    (1, 1, 'Backend Engineer',           'https://datastreamlabs.io/jobs/backend',    110000, 140000, 'New York, NY',     'hybrid',  'ghosted',      '2025-09-02', NULL,         '2025-10-01', 3, 'Never heard back. Applied cold.'),
    (2, 2, 'Software Engineer II',       'https://boltfinancial.com/jobs/swe2',       120000, 155000, 'San Francisco, CA','hybrid',  'rejected',     '2025-09-03', '2025-09-10', '2025-09-10', 3, 'Automated rejection email after 1 week.'),
    (3, 3, 'Senior Developer',           'https://meridianhealthtech.com/jobs/sr-dev', 130000, 160000, 'Remote',          'remote',  'rejected',     '2025-09-05', '2025-09-20', '2025-10-15', 4, 'Made it to round 2 then got cut.'),
    (5, 2, 'Technical Consultant',       'https://pinnaclegroup.com/jobs/tc',          95000, 125000, 'Chicago, IL',      'onsite',  'ghosted',      '2025-09-08', NULL,         '2025-10-08', 2, 'Safety net application. Not excited.'),

    -- week 3-4: getting more targeted
    (4, 7, 'Full Stack Developer',       'https://canopysoftware.dev/jobs/fullstack', 125000, 150000, 'Remote',           'remote',  'offer',        '2025-09-15', '2025-09-18', '2025-11-01', 5, 'Found on HN Who is Hiring. Dream job.'),
    (6, 1, 'ML Platform Engineer',       'https://novabridgeai.com/jobs/ml-plat',    140000, 175000, 'New York, NY',     'hybrid',  'rejected',     '2025-09-16', '2025-09-22', '2025-10-20', 4, 'Great interviews but they went with someone more senior.'),
    (7, 6, 'Software Engineer',          'https://greenlinelogistics.com/jobs/swe',  105000, 135000, 'Remote',           'remote',  'interviewing', '2025-09-18', '2025-09-25', NULL,         3, 'Process is slow but still active.'),

    -- week 5-6: referrals start kicking in
    (10, 4, 'Platform Engineer',         'https://cloudpeaksystems.io/jobs/platform', 130000, 165000, 'Denver, CO',      'hybrid',  'offer',        '2025-09-22', '2025-09-24', '2025-10-28', 5, 'Friend referral. Whole process took 5 weeks.'),
    (8,  5, 'Senior Full Stack Engineer','https://apexdigital.co/jobs/sr-fullstack', 135000, 170000, 'Remote',           'remote',  'interviewing', '2025-09-25', '2025-09-26', NULL,         4, 'Recruiter reached out on LinkedIn. Moving fast.'),
    (9,  1, 'Software Developer',        'https://rivermountpartners.com/jobs/dev',  115000, 145000, 'Boston, MA',       'hybrid',  'phone_screen', '2025-09-28', '2025-10-05', NULL,         2, 'Applied as backup. Comp is good though.'),

    -- month 2-3: more selective
    (6,  5, 'Senior ML Engineer',        'https://novabridgeai.com/jobs/sr-ml',      155000, 190000, 'New York, NY',     'hybrid',  'applied',      '2025-10-10', NULL,         NULL,         4, 'Different role at same company. Recruiter encouraged me to reapply.'),
    (1,  4, 'Senior Backend Engineer',   'https://datastreamlabs.io/jobs/sr-backend',130000, 160000, 'New York, NY',     'hybrid',  'phone_screen', '2025-10-15', '2025-10-17', NULL,         3, 'Got a referral this time. Actually heard back.'),
    (4,  7, 'DevOps Engineer',           'https://canopysoftware.dev/jobs/devops',   120000, 145000, 'Remote',           'remote',  'applied',      '2025-10-20', NULL,         NULL,         4, 'Second role at Canopy. Loved the team from first process.'),
    (3,  3, 'Engineering Manager',       'https://meridianhealthtech.com/jobs/em',   150000, 180000, 'Remote',           'remote',  'applied',      '2025-10-25', NULL,         NULL,         3, 'Different team than before. Worth a shot.'),
    (7,  6, 'Senior Software Engineer',  'https://greenlinelogistics.com/jobs/sr',   120000, 150000, 'Remote',           'remote',  'applied',      '2025-10-28', NULL,         NULL,         3, 'Applied to senior role while still interviewing for mid.');


INSERT INTO contacts (company_id, application_id, name, role, email, linkedin_url, relationship, notes) VALUES
    (4,  5,  'Sarah Chen',       'Engineering Manager',    'sarah@canopysoftware.dev',    'linkedin.com/in/sarahchen',     'hiring_manager', 'Super responsive. Gave great feedback after each round.'),
    (4,  5,  'Mike Torres',      'Senior Engineer',        'mike@canopysoftware.dev',     'linkedin.com/in/miketorres',    'peer',           'Did my technical interview. Chill guy.'),
    (10, 8,  'James Liu',        'Staff Engineer',         'james@cloudpeaksystems.io',   'linkedin.com/in/jamesliu',      'referral',       'College friend. Referred me and prepped me for interviews.'),
    (10, 8,  'Andrea Patel',     'VP Engineering',         'andrea@cloudpeaksystems.io',  'linkedin.com/in/andreapatel',   'hiring_manager', 'Final round was with her. Intense but fair.'),
    (6,  6,  'David Kim',        'Recruiter',              'david@novabridgeai.com',      'linkedin.com/in/davidkim',      'recruiter',      'Gave honest feedback about why I didnt get the first role.'),
    (8,  9,  'Rachel Green',     'Technical Recruiter',    'rachel@apexdigital.co',       'linkedin.com/in/rachelgreen',   'recruiter',      'Reached out to me. Very on top of scheduling.'),
    (3,  3,  'Tom Bradley',      'Engineering Director',   'tom@meridianhealthtech.com',  'linkedin.com/in/tombradley',    'hiring_manager', 'Seemed checked out during the interview honestly.'),
    (7,  7,  'Nina Kowalski',    'HR Manager',             'nina@greenlinelogistics.com', 'linkedin.com/in/ninakowalski',  'recruiter',      'Nice but the process is painfully slow.'),
    (1,  12, 'Alex Rivera',      'Tech Lead',              'alex@datastreamlabs.io',      'linkedin.com/in/alexrivera',    'referral',       'Met at a meetup. Got me the second interview.');


INSERT INTO interviews (application_id, round_number, interview_type, scheduled_at, duration_minutes, interviewer_name, interviewer_role, went_well, notes) VALUES
    -- Meridian Health Tech (rejected after round 2)
    (3,  1, 'phone_screen',   '2025-09-22 10:00', 30,  'Tom Bradley',    'Engineering Director', true,  'Basic questions. Went fine.'),
    (3,  2, 'technical',       '2025-10-01 14:00', 60,  'Unknown',        'Senior Engineer',      false, 'System design question I wasnt ready for. Bombed it.'),

    -- Canopy Software (offer!)
    (5,  1, 'phone_screen',   '2025-09-20 11:00', 30,  'Sarah Chen',     'Engineering Manager',  true,  'Great conversation. She was genuinely excited about my background.'),
    (5,  2, 'technical',       '2025-09-27 13:00', 90,  'Mike Torres',    'Senior Engineer',      true,  'Pair programming on a real codebase. Best interview format ever.'),
    (5,  3, 'behavioral',     '2025-10-04 15:00', 45,  'Sarah Chen',     'Engineering Manager',  true,  'Talked about team dynamics and how I handle ambiguity.'),
    (5,  4, 'panel',           '2025-10-10 10:00', 60,  'Leadership Team','Mixed',                true,  'Met the CTO. Asked good questions about their roadmap.'),

    -- NovaBridge AI (rejected after round 3)
    (6,  1, 'phone_screen',   '2025-09-24 09:00', 30,  'David Kim',      'Recruiter',            true,  'Standard recruiter screen. No red flags.'),
    (6,  2, 'technical',       '2025-10-02 11:00', 75,  'Unknown',        'ML Engineer',          true,  'Coding challenge went well. Good discussion about tradeoffs.'),
    (6,  3, 'system_design',  '2025-10-12 14:00', 60,  'Unknown',        'Staff Engineer',       false, 'Got positive feedback but they wanted more ML depth.'),

    -- Cloudpeak Systems (offer!)
    (8,  1, 'phone_screen',   '2025-09-26 10:00', 30,  'HR',             'Recruiter',            true,  'Quick and easy. James prepped me well.'),
    (8,  2, 'technical',       '2025-10-03 13:00', 90,  'James Liu',      'Staff Engineer',       true,  'My friend interviewed me lol. Still professional though.'),
    (8,  3, 'system_design',  '2025-10-10 11:00', 60,  'Unknown',        'Principal Engineer',   true,  'Designed a distributed queue system. Got good feedback.'),
    (8,  4, 'behavioral',     '2025-10-17 15:00', 45,  'Andrea Patel',   'VP Engineering',       true,  'She grilled me on leadership. Intense but I held my own.'),

    -- Greenline (still interviewing)
    (7,  1, 'phone_screen',   '2025-09-29 14:00', 30,  'Nina Kowalski',  'HR Manager',           true,  'Basic screen. Took them a week just to schedule this.'),
    (7,  2, 'technical',       '2025-10-15 10:00', 60,  'Unknown',        'Senior Engineer',      true,  'Take-home was fine. Waiting on next steps.'),

    -- Apex Digital (still interviewing)
    (9,  1, 'phone_screen',   '2025-09-28 11:00', 30,  'Rachel Green',   'Technical Recruiter',  true,  'She had clearly read my resume. Refreshing.'),
    (9,  2, 'technical',       '2025-10-08 13:00', 75,  'Unknown',        'Engineering Manager',  true,  'Live coding. Built a small API endpoint. Went smoothly.');


INSERT INTO follow_ups (application_id, contact_id, follow_up_type, sent_at, method, content_summary, got_response) VALUES
    -- thank yous after Canopy interviews
    (5, 1, 'thank_you',    '2025-09-20 17:00', 'email',    'Thanked Sarah for the great intro call.',                       true),
    (5, 2, 'thank_you',    '2025-09-27 18:00', 'email',    'Thanked Mike for the pair programming session.',                false),
    (5, 1, 'thank_you',    '2025-10-04 17:00', 'email',    'Followed up on behavioral round. Asked about next steps.',     true),
    (5, 1, 'negotiation',  '2025-10-18 10:00', 'email',    'Negotiated salary. Asked for 145k base + signing bonus.',       true),

    -- Cloudpeak follow-ups
    (8, 3, 'thank_you',    '2025-09-26 16:00', 'linkedin', 'Thanked James for the referral.',                               true),
    (8, 4, 'thank_you',    '2025-10-17 17:00', 'email',    'Thanked Andrea for her time.',                                  true),
    (8, 4, 'negotiation',  '2025-10-24 09:00', 'email',    'Counter-offered. Used Canopy offer as leverage.',               true),

    -- NovaBridge rejection follow-up
    (6, 5, 'check_in',     '2025-10-22 10:00', 'email',    'Asked David for specific feedback. He said try again in 6 months.', true),

    -- check-ins on slow processes
    (7, 8, 'check_in',     '2025-10-08 09:00', 'email',    'Asked Nina for timeline update. She said 1-2 more weeks.',      true),
    (7, 8, 'check_in',     '2025-10-22 09:00', 'email',    'Another check-in. Still waiting.',                               false),

    -- Datastream second attempt
    (12, 9, 'thank_you',   '2025-10-17 16:00', 'email',    'Thanked Alex for getting me the phone screen.',                  true);
