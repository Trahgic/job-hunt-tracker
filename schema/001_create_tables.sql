-- job-hunt-tracker schema
-- tracks job applications, interviews, contacts, and outcomes
-- built on PostgreSQL 15+

-- dropping in reverse dependency order so foreign keys don't complain
DROP TABLE IF EXISTS follow_ups;
DROP TABLE IF EXISTS interviews;
DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS referral_sources;


CREATE TABLE referral_sources (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE  -- e.g. 'LinkedIn', 'Company Website', 'Friend Referral'
);


CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    industry VARCHAR(100),
    company_size VARCHAR(50),  -- 'startup', 'mid', 'enterprise'
    careers_url TEXT,
    glassdoor_rating NUMERIC(2,1),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- one index we'll actually use: searching companies by name
CREATE INDEX idx_companies_name ON companies(name);


CREATE TABLE applications (
    id SERIAL PRIMARY KEY,
    company_id INT NOT NULL REFERENCES companies(id),
    source_id INT REFERENCES referral_sources(id),
    position_title VARCHAR(200) NOT NULL,
    job_url TEXT,
    salary_min INT,  -- storing as integers, no need for decimals on salary ranges
    salary_max INT,
    location VARCHAR(200),
    remote_policy VARCHAR(50),  -- 'remote', 'hybrid', 'onsite'
    status VARCHAR(50) NOT NULL DEFAULT 'applied',
        -- applied -> phone_screen -> interviewing -> offer -> accepted/rejected/ghosted
    applied_date DATE NOT NULL,
    response_date DATE,  -- when they first got back to you (null = still waiting)
    closed_date DATE,    -- when the process ended one way or another
    excitement_level INT CHECK (excitement_level BETWEEN 1 AND 5),
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_applications_status ON applications(status);
CREATE INDEX idx_applications_applied_date ON applications(applied_date);


CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    company_id INT NOT NULL REFERENCES companies(id),
    application_id INT REFERENCES applications(id),  -- nullable, might know someone before applying
    name VARCHAR(200) NOT NULL,
    role VARCHAR(200),
    email VARCHAR(200),
    linkedin_url TEXT,
    relationship VARCHAR(100),  -- 'recruiter', 'hiring_manager', 'peer', 'referral'
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);


CREATE TABLE interviews (
    id SERIAL PRIMARY KEY,
    application_id INT NOT NULL REFERENCES applications(id),
    round_number INT NOT NULL,  -- 1 = phone screen, 2 = technical, 3 = onsite, etc.
    interview_type VARCHAR(100),  -- 'phone_screen', 'technical', 'behavioral', 'system_design', 'take_home', 'panel'
    scheduled_at TIMESTAMP,
    duration_minutes INT,
    interviewer_name VARCHAR(200),
    interviewer_role VARCHAR(200),
    went_well BOOLEAN,  -- gut feeling right after
    notes TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_interviews_application ON interviews(application_id);


CREATE TABLE follow_ups (
    id SERIAL PRIMARY KEY,
    application_id INT NOT NULL REFERENCES applications(id),
    contact_id INT REFERENCES contacts(id),
    follow_up_type VARCHAR(100) NOT NULL,  -- 'thank_you', 'check_in', 'negotiation', 'withdrawal'
    sent_at TIMESTAMP NOT NULL,
    method VARCHAR(50),  -- 'email', 'linkedin', 'phone'
    content_summary TEXT,
    got_response BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);
