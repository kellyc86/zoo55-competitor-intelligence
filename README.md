# Zoo 55 Competitor Intelligence Dashboard

A YouTube competitive intelligence tool built to benchmark digital entertainment channels across upload cadence, engagement rate, content velocity and audience growth — built using the exact stack used by ITV's Global Data & Insights team.

**Live Dashboard:** [View on Looker Studio](https://lookerstudio.google.com/s/qvbPbGYvI2E)

---

## What it does

Pulls public data from the YouTube Data API v3 for 9 competitor channels, loads it into BigQuery, and surfaces insights via a Looker Studio dashboard — directly answering the key questions a digital media business like Zoo 55 needs:

- Which competitor is publishing most frequently, and is it working?
- Whose content drives the highest engagement relative to views?
- What genres and formats are performing best across the market?
- Which content has the best velocity (views per day) post-publish?

---

## Tech Stack

| Layer | Tool | Relevant to Zoo 55 JD |
|---|---|---|
| Data collection | Python 3.11 + YouTube Data API v3 | Python / statistical analysis |
| Storage & transformation | Google BigQuery (GCP) | GCP / BigQuery — minimum criteria |
| Visualisation | Looker Studio | Looker Studio — minimum criteria |
| Version control | GitHub | Engineering best practice |

---

## Channels Analysed

| Channel | Subscribers | Videos | Notes |
|---|---|---|---|
| BBC Studios | 3,860,000 | 5,421 | Scale benchmark |
| Banijay Documentaries | 1,350,000 | 2,679 | Genre channel model |
| Banijay History | 1,010,000 | 911 | Genre channel model |
| Banijay Crime | 988,000 | 1,513 | Genre channel model |
| Channel 4 | 726,000 | 3,011 | Volume-led strategy |
| Banijay Science | 621,000 | 1,222 | Genre channel model |
| Warner Bros. TV | 827,000 | 2,311 | General channel model |
| Sony Pictures Television | 825,000 | 1,980 | General channel model |
| Fremantle | 70,300 | 114 | Major gap identified |

**Total: 450 videos collected · 14 metrics per video**

---

## Data & Analytics

### Metrics collected per video
- Views, likes, comments
- Engagement rate = (likes + comments) / views × 100
- Views per day = views / days since publish (content velocity)
- Duration, tags, publish date, description length, category

### Analytics performed
- **Channel benchmarking** — subscriber count, total views and video count across all 9 channels
- **Engagement rate analysis** — identifying which channels drive the most audience interaction relative to views
- **Content velocity analysis** — views per day metric to surface fastest-growing content regardless of age
- **Upload cadence analysis** — frequency of publishing compared across competitors
- **Top content identification** — ranking videos by views and engagement to surface winning formats
- **Genre channel strategy analysis** — single brand channels vs genre-segmented channel networks

---

## Key Insights

### 1. BBC Studios is the scale benchmark
- 3.86M subscribers and 5,421 videos — the largest catalogue YouTube presence in the competitor set
- Nearly 3x more content than any other competitor, demonstrating that catalogue depth drives long-term subscriber growth
- With 95,000+ hours of ITV Studios catalogue, Zoo 55 has the raw material to compete — the question is speed of deployment

### 2. Banijay's genre channel strategy is the most instructive
- 4 genre channels combined reach ~3.97M subscribers — comparable to BBC Studios' single channel
- Each channel has a focused content identity: Documentaries, History, Crime, Science
- Directly validates Zoo 55's own genre channel model — the data confirms this approach works at scale

### 3. True crime and science are the highest-performing genres
- Banijay Crime: 988K subscribers with 1,513 videos — strong subscriber-to-video efficiency
- Banijay Science: 621K subscribers with 1,222 videos — consistent growth trajectory
- These genres consistently appear in the top performing videos by both views and engagement rate
- If Zoo 55 does not have dedicated crime and science channels, this data signals a clear gap opportunity

### 4. Channel 4 punches above its weight
- 726K subscribers with 3,011 videos — strong presence for a broadcaster-owned channel
- High video volume suggests an aggressive upload strategy rather than selective catalogue curation
- An alternative model to Banijay's genre-focus strategy worth benchmarking against

### 5. Fremantle is a major gap in the market
- Only 70,300 subscribers and 114 videos despite owning Got Talent, X Factor and Idol globally
- Fremantle's underinvestment in YouTube catalogue monetisation is the biggest white space identified in this analysis
- Zoo 55 can position itself to out-execute Fremantle in catalogue digitalisation — a concrete competitive advantage

### 6. Warner Bros. and Sony reveal a general channel ceiling
- Both sit at ~825–827K subscribers despite very different catalogue sizes
- Neither has adopted a genre channel strategy — both run single general entertainment channels
- Genre segmentation appears to break through the ceiling that general channels hit — further evidence for Zoo 55's strategic direction

---

## Strategic Recommendation

The data consistently points to one conclusion: **genre-specific channel networks outperform general studio channels at every scale.** Banijay's four-channel network collectively outperforms Warner Bros. and Sony's single channels despite those studios having far larger catalogues.

For Zoo 55, this validates the current genre channel strategy and suggests the priority should be accelerating the launch of additional genre channels — particularly in **true crime and science** — where audience demand is demonstrably high and competitor supply is underserving the market.

Fremantle's near-absence from YouTube despite its catalogue scale represents the single biggest white space opportunity identified in this analysis.

---

## Project Structure

```
├── collect_data.py          # Pulls channel + video data from YouTube API
├── upload_to_bigquery.py    # Loads CSVs into BigQuery tables
├── sql/
│   └── analysis_queries.sql # SQL queries powering the dashboard
├── data/                    # Generated CSVs (gitignored)
├── requirements.txt
├── .env.example
└── .gitignore
```

---

## Setup

```bash
# Clone the repo
git clone https://github.com/kellyc86/zoo55-competitor-intelligence
cd zoo55-competitor-intelligence

# Create conda environment
conda create -n zoo55 python=3.11 -y
conda activate zoo55
pip install -r requirements.txt

# Add your credentials
cp .env.example .env
# Edit .env with your YouTube API key and GCP project ID

# Run the pipeline
python collect_data.py          # Step 1: collect data
python upload_to_bigquery.py    # Step 2: upload to BigQuery
# Step 3: connect Looker Studio to BigQuery at studio.google.com
```

---

## Live Dashboard

**[View the Looker Studio Dashboard](https://lookerstudio.google.com/s/qvbPbGYvI2E)**

The dashboard includes:
- Channel KPI scorecard
- Engagement rate comparison across competitors
- Total views by channel
- Top performing videos table with engagement and velocity metrics

---

*Built as a competitive intelligence proof-of-concept. All data sourced from the public YouTube Data API v3.*
