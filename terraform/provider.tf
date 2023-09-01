# Configure the AWS provider
provider "aws" {
  region     = "us-west-2"
  access_key = "1234567890"
  secret_key = "xxxxxxxxxxxxxxxxxxxxxxxx"
}

# Configure the Google Cloud (GCP) provider
provider "google" {
  credentials = file("path/to/your/gcp/credentials.json")
  project     = "gcp-project-id"
  region      = "us-central1"  # Specify the desired GCP region
}

# Configure the Azure provider
provider "azurerm" {
  features {}
  subscription_id = "azure-subscription-id"
  client_id       = "azure-client-id"
  client_secret   = "azure-client-secret"
  tenant_id       = "azure-tenant-id"
}

