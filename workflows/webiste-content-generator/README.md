# Website Content Generator — Workflows Overview

This folder contains n8n workflows and the database schema used to generate, write, and publish SEO content for multiple websites.

Workflows:
- Keyword Agent — extracts keyword suggestions and inserts into the `keywords` table.
- Topic Agent — selects low-usage keywords, asks an AI to generate article topics, and inserts into the `topics` table.
- Writer Agent — picks `new` topics, generates article markdown + HTML, inserts into the `articles` table and marks topics as written.
- Publisher Agent — converts article HTML into publication-ready HTML, generates meta title/description, updates `articles`, and optionally publishes to WordPress.
- Resume writer Agent — separate workflow for generating job-specific resumes and storing vectors in PGVector.

Database schema:
- See [`DBschema.sql`](workflows/webiste-content-generator/DBschema.sql) for the tables and columns used.
  - Tables referenced in workflows: [`DBschema.websites`](workflows/webiste-content-generator/DBschema.sql), [`DBschema.keywords`](workflows/webiste-content-generator/DBschema.sql), [`DBschema.topics`](workflows/webiste-content-generator/DBschema.sql), [`DBschema.articles`](workflows/webiste-content-generator/DBschema.sql).
