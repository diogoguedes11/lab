
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region = "europe-west1"
}


resource "google_storage_bucket" "this" {
  name     = "cf-bucket-test-demo11"
  location = "US"
}

resource "google_storage_bucket_object" "this" {
  name   = "index.zip"
  bucket = google_storage_bucket.this.name
  source = "../index.zip"
}

resource "google_cloudfunctions_function" "function" {
  name        = "cf-nba-leaderboard"
  description = "NBA Player Leaderboard"
  runtime     = "python310"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.this.name
  source_archive_object = google_storage_bucket_object.this.name
  trigger_http          = true
  entry_point           = "nba_leaderboard_scrape"
}

# IAM entry for all users to invoke the function
resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = google_cloudfunctions_function.function.project
  region         = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name

  role   = "roles/cloudfunctions.invoker"
  member = "allUsers"
}