terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "5.11.0"
    }
  }
}

provider "github" {
  token = "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"
}
resource "github_repository" "amdoc-tf" {
  name        = "Amdocs_Terraform_Training_Jagdish_Dec_2022"
  description = "My terraform codebase"

  visibility = "public"
} 
