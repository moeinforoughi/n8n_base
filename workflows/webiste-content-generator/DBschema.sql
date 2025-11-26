-- =======================================================
-- MASTER DATABASE SCHEMA
-- AI Content Generation & Publishing System
-- =======================================================
-- This schema powers a multi-website platform for:
-- - Topic generation
-- - Keyword collection & tracking
-- - Content creation (markdown + HTML)
-- - Internal linking automation
-- - Publishing workflow
--
-- Notes:
-- - All timestamps default to NOW()
-- - JSONB is used for flexible metadata, keyword lists,
--   internal link structures, and other variable objects.
-- - ON DELETE CASCADE ensures clean removal of related data.
-- =======================================================



-- =======================================================
-- 1. WEBSITES
-- =======================================================
-- Stores configuration, defaults, and metadata for each site.
-- Every topic and article belongs to a website.
-- JSONB 'default_keywords' seeds keyword generation for that site.
-- =======================================================

CREATE TABLE websites (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    base_url TEXT,
    description TEXT,
    sitemap_url TEXT,
    default_keywords JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);




-- =======================================================
-- 2. KEYWORDS
-- =======================================================
-- Tracks keywords tied to each website.
-- 'source' can indicate:
-- - "manual"
-- - "ai_generated"
-- - "crawler"
-- - "imported"
--
-- 'usage_count' increments whenever a keyword is used in a topic.
--
-- UNIQUE CONSTRAINT prevents duplicates per website+keyword+source.
-- =======================================================

CREATE TABLE keywords (
    id SERIAL PRIMARY KEY,
    website_id INTEGER NOT NULL REFERENCES websites(id) ON DELETE CASCADE,
    keyword TEXT NOT NULL,
    source TEXT,
    usage_count INTEGER DEFAULT 0,
    last_used_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Prevent duplicate keywords for the same site & source
ALTER TABLE keywords
ADD CONSTRAINT unique_keyword_per_site UNIQUE (website_id, keyword, source);




-- =======================================================
-- 3. TOPICS
-- =======================================================
-- Represents a generated idea/topic to be turned into an article.
-- 'status' is used for workflow:
-- - "new"
-- - "processing"
-- - "completed"
-- - "published"
--
-- 'keywords_used' JSONB stores an array of related keywords.
-- Example:
--     ["ai workflows", "automation", "deep learning"]
-- =======================================================

CREATE TABLE topics (
    id SERIAL PRIMARY KEY,
    website_id INTEGER NOT NULL REFERENCES websites(id) ON DELETE CASCADE,
    topic_title TEXT NOT NULL,
    slug TEXT,
    status TEXT DEFAULT 'new',
    priority INTEGER,
    keywords_used JSONB,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);




-- =======================================================
-- 4. ARTICLES
-- =======================================================
-- Stores full generated content for a topic.
--
-- CONTENT:
-- - 'content_markdown' → used for further editing
-- - 'content_html' → used for publishing
--
-- METADATA:
-- - SEO fields: meta_title, meta_description
-- - 'internal_links' JSONB stores auto-generated links like:
--     [
--       {"anchor": "AI tools", "url": "/ai-tools"},
--       {"anchor": "deep learning", "url": "/deep-learning"}
--     ]
--
-- 'status' controls workflow:
-- - "draft"
-- - "generated"
-- - "ready"
-- - "published"
-- =======================================================

CREATE TABLE articles (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    website_id INTEGER NOT NULL REFERENCES websites(id) ON DELETE CASCADE,
    content_markdown TEXT,
    content_html TEXT,
    meta_title TEXT,
    meta_description TEXT,
    status TEXT DEFAULT 'draft',
    internal_links JSONB,
    published_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);
