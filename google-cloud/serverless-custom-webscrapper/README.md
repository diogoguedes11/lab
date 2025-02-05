# NBA Web Scraper Cloud Function

## Overview

This simple project consists of a serverless cloud function that scrapes the NBA stats leaderboard from the official NBA website. It utilizes Python with the `requests` and `BeautifulSoup` libraries to fetch and parse HTML content. The results are returned as a JSON response, making it easy to integrate with various applications.

The project is designed to be deployed on Google Cloud using Terraform, providing an automated way to manage infrastructure.

## Features

- Scrapes the top players from the NBA leaderboard.
- Returns leaderboard titles and player information as JSON.
- Utilizes Terraform for deployment and management of cloud resources.

## Technologies Used

- Python
- Flask (for building the cloud function)
- Requests (for making HTTP requests)
- BeautifulSoup (for parsing HTML content)
- Terraform (for provisioning cloud infrastructure)

## Setup Instructions

### Prerequisites

Before you begin, ensure you have the following installed:

- Python 3.x
- Pip (Python package manager)
- Terraform
- Google Cloud SDK (with appropriate permissions for deploying functions)

### Installation

1. **Clone the repository**:

   ```bash
   git clone git@github.com:diogobytes/cloud-projects.git
   cd cloud-projects/gcp/serverless-custom-webscrapper/terraform

   terraform init
   terraform plan
   terraform apply
   ```