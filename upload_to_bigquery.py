"""
Zoo 55 Competitor Intelligence: BigQuery Uploader
Creates dataset + tables in BigQuery and loads CSV data.
Run this after collect_data.py has produced the CSV files.
"""

import os
from google.cloud import bigquery
from google.oauth2 import service_account
from dotenv import load_dotenv

load_dotenv()

# -------------------------------------------------------------------
# Config — update these to match your GCP project
# -------------------------------------------------------------------
PROJECT_ID  = os.getenv("GCP_PROJECT_ID")   # e.g. "zoo55-competitor-intel"
DATASET_ID  = "youtube_competitor_data"
CREDENTIALS = os.getenv("GOOGLE_APPLICATION_CREDENTIALS")  # path to service account JSON

client = bigquery.Client(project=PROJECT_ID)


# -------------------------------------------------------------------
# Table schemas — match the columns in our CSV files
# -------------------------------------------------------------------
CHANNEL_SCHEMA = [
    bigquery.SchemaField("channel_id",        "STRING",    mode="REQUIRED"),
    bigquery.SchemaField("channel_name",       "STRING"),
    bigquery.SchemaField("subscriber_count",   "INTEGER"),
    bigquery.SchemaField("total_views",        "INTEGER"),
    bigquery.SchemaField("video_count",        "INTEGER"),
    bigquery.SchemaField("country",            "STRING"),
    bigquery.SchemaField("published_at",       "TIMESTAMP"),
    bigquery.SchemaField("collected_at",       "TIMESTAMP"),
]

VIDEO_SCHEMA = [
    bigquery.SchemaField("video_id",           "STRING",    mode="REQUIRED"),
    bigquery.SchemaField("channel_id",         "STRING"),
    bigquery.SchemaField("channel_name",       "STRING"),
    bigquery.SchemaField("title",              "STRING"),
    bigquery.SchemaField("publish_date",       "TIMESTAMP"),
    bigquery.SchemaField("days_since_publish", "INTEGER"),
    bigquery.SchemaField("duration",           "STRING"),
    bigquery.SchemaField("views",              "INTEGER"),
    bigquery.SchemaField("likes",              "INTEGER"),
    bigquery.SchemaField("comments",           "INTEGER"),
    bigquery.SchemaField("engagement_rate",    "FLOAT"),
    bigquery.SchemaField("views_per_day",      "FLOAT"),
    bigquery.SchemaField("category_id",        "STRING"),
    bigquery.SchemaField("tags",               "STRING"),
    bigquery.SchemaField("description_length", "INTEGER"),
    bigquery.SchemaField("collected_at",       "TIMESTAMP"),
]


def create_dataset():
    dataset_ref = bigquery.Dataset(f"{PROJECT_ID}.{DATASET_ID}")
    dataset_ref.location = "EU"  # Keep data in Europe
    dataset = client.create_dataset(dataset_ref, exists_ok=True)
    print(f"Dataset ready: {DATASET_ID}")
    return dataset


def upload_csv(table_id, csv_path, schema):
    table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table_id}"

    job_config = bigquery.LoadJobConfig(
        schema=schema,
        skip_leading_rows=1,       # skip header row
        source_format=bigquery.SourceFormat.CSV,
        write_disposition=bigquery.WriteDisposition.WRITE_TRUNCATE,  # overwrite on re-run
        allow_quoted_newlines=True,
    )

    with open(csv_path, "rb") as f:
        job = client.load_table_from_file(f, table_ref, job_config=job_config)
        job.result()  # wait for completion

    table = client.get_table(table_ref)
    print(f"  Uploaded {table.num_rows} rows → {table_ref}")


def main():
    print("Zoo 55 Competitor Intelligence — BigQuery Upload")
    print("=" * 50)

    create_dataset()

    print("\nUploading channel stats...")
    upload_csv("channel_stats", "data/channel_stats.csv", CHANNEL_SCHEMA)

    print("Uploading video data...")
    upload_csv("video_data", "data/video_data.csv", VIDEO_SCHEMA)

    print("\nDone. Connect Looker Studio to BigQuery to build your dashboard.")
    print(f"Dataset: {PROJECT_ID}.{DATASET_ID}")


if __name__ == "__main__":
    main()
