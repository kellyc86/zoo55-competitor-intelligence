-- ================================================================
-- Zoo 55 Competitor Intelligence — BigQuery SQL Queries
-- Run these in BigQuery after upload_to_bigquery.py completes
-- These power the Looker Studio dashboard
-- ================================================================


-- ----------------------------------------------------------------
-- 1. CHANNEL BENCHMARK OVERVIEW
-- Who has the biggest audience and most content?
-- ----------------------------------------------------------------
SELECT
    channel_name,
    subscriber_count,
    total_views,
    video_count,
    ROUND(total_views / NULLIF(video_count, 0), 0) AS avg_views_per_video,
    ROUND(subscriber_count / 1000000, 2)            AS subscribers_millions
FROM `youtube_competitor_data.channel_stats`
ORDER BY subscriber_count DESC;


-- ----------------------------------------------------------------
-- 2. ENGAGEMENT RATE BY CHANNEL
-- Who drives the most interaction relative to their views?
-- High engagement = content that resonates — key Zoo 55 signal
-- ----------------------------------------------------------------
SELECT
    channel_name,
    COUNT(video_id)                        AS videos_analysed,
    ROUND(AVG(engagement_rate), 3)         AS avg_engagement_rate_pct,
    ROUND(AVG(views), 0)                   AS avg_views,
    ROUND(AVG(views_per_day), 1)           AS avg_views_per_day,
    MAX(views)                             AS best_performing_video_views
FROM `youtube_competitor_data.video_data`
GROUP BY channel_name
ORDER BY avg_engagement_rate_pct DESC;


-- ----------------------------------------------------------------
-- 3. UPLOAD CADENCE ANALYSIS
-- How often does each competitor publish? (weekly rhythm)
-- ----------------------------------------------------------------
SELECT
    channel_name,
    EXTRACT(YEAR  FROM publish_date) AS year,
    EXTRACT(WEEK  FROM publish_date) AS week_number,
    COUNT(video_id)                  AS videos_published
FROM `youtube_competitor_data.video_data`
GROUP BY channel_name, year, week_number
ORDER BY channel_name, year, week_number;


-- ----------------------------------------------------------------
-- 4. TOP 10 BEST PERFORMING VIDEOS OVERALL
-- Surface the content formats that are winning across competitors
-- ----------------------------------------------------------------
SELECT
    channel_name,
    title,
    views,
    likes,
    comments,
    engagement_rate,
    views_per_day,
    DATE(publish_date) AS publish_date
FROM `youtube_competitor_data.video_data`
ORDER BY views DESC
LIMIT 10;


-- ----------------------------------------------------------------
-- 5. CONTENT VELOCITY — views_per_day by channel
-- Which competitor's content keeps growing fastest post-publish?
-- ----------------------------------------------------------------
SELECT
    channel_name,
    CASE
        WHEN days_since_publish <= 7   THEN '0-7 days old'
        WHEN days_since_publish <= 30  THEN '8-30 days old'
        WHEN days_since_publish <= 90  THEN '31-90 days old'
        ELSE '90+ days old'
    END AS content_age_bucket,
    COUNT(video_id)                AS video_count,
    ROUND(AVG(views_per_day), 1)   AS avg_views_per_day
FROM `youtube_competitor_data.video_data`
GROUP BY channel_name, content_age_bucket
ORDER BY channel_name, avg_views_per_day DESC;


-- ----------------------------------------------------------------
-- 6. GENRE / TAG ANALYSIS
-- What topics/themes are competitors doubling down on?
-- Split tags (pipe-separated) to count topic frequency
-- ----------------------------------------------------------------
SELECT
    channel_name,
    tag,
    COUNT(*) AS tag_frequency
FROM `youtube_competitor_data.video_data`,
    UNNEST(SPLIT(tags, '|')) AS tag
WHERE tag != ''
GROUP BY channel_name, tag
ORDER BY tag_frequency DESC
LIMIT 50;


-- ----------------------------------------------------------------
-- 7. MONTHLY PUBLISHING TREND
-- Is content output growing, shrinking, or flat over time?
-- ----------------------------------------------------------------
SELECT
    channel_name,
    FORMAT_DATE('%Y-%m', DATE(publish_date)) AS month,
    COUNT(video_id)                           AS videos_published,
    SUM(views)                                AS total_views_that_month,
    ROUND(AVG(engagement_rate), 3)            AS avg_engagement_rate
FROM `youtube_competitor_data.video_data`
GROUP BY channel_name, month
ORDER BY channel_name, month;


-- ----------------------------------------------------------------
-- 8. EXECUTIVE SUMMARY VIEW (use this as a Looker Studio data source)
-- One row per channel — the KPI scorecard
-- ----------------------------------------------------------------
CREATE OR REPLACE VIEW `youtube_competitor_data.executive_summary` AS
SELECT
    c.channel_name,
    c.subscriber_count,
    c.total_views,
    c.video_count,
    ROUND(v.avg_eng, 3)          AS avg_engagement_rate_pct,
    ROUND(v.avg_vpd, 1)          AS avg_views_per_day,
    ROUND(v.avg_views, 0)        AS avg_views_per_video,
    v.top_video_views,
    v.videos_analysed
FROM `youtube_competitor_data.channel_stats` c
LEFT JOIN (
    SELECT
        channel_name,
        COUNT(video_id)          AS videos_analysed,
        AVG(engagement_rate)     AS avg_eng,
        AVG(views_per_day)       AS avg_vpd,
        AVG(views)               AS avg_views,
        MAX(views)               AS top_video_views
    FROM `youtube_competitor_data.video_data`
    GROUP BY channel_name
) v ON c.channel_name = v.channel_name;
