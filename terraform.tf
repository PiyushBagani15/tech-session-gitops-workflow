terraform {
  cloud {
    organization = "tech-session-demo"

    workspaces {
      name = "tech-session-gitops-prod"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}
