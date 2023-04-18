variable "job_name" {
  description = "Name for the job"
  type        = string
  default = "arroyo-cluster"
}

variable "region" {
  description = "The region where jobs will be deployed"
  type        = string
  default     = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "prometheus_endpoint" {
  description = "Endpoint for prometheus, required for job metrics"
  type        = string
  default     = "http://localhost:9090"
}

variable "prometheus_auth" {
  description = "Basic authentication for prometheus"
  type        = string
  default     = ""
}

variable "postgres_host" {
  description = "Host of your postgres database"
  type        = string
  default     = "127.0.0.1"
}

variable "postgres_port" {
  description = "Port of your postgres database"
  type        = number
  default     = 5432
}

variable "postgres_db" {
  description = "Name of your postgres database"
  type        = string
  default     = "arroyo"
}

variable "postgres_user" {
  description = "User of your postgres database"
  type        = string
  default     = "arroyo"
}

variable "postgres_password" {
  description = "Password of your postgres database"
  type        = string
  default     = "arroyo"
}

variable "s3_region" {
  description = "S3 bucket to store checkpoints and pipeline artifacts"
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket" {
  description = "S3 bucket to store checkpoints and pipeline artifacts"
  type        = string
}

variable "nomad_api" {
  description = "Nomad API endpoint"
  type        = string
  default     = "http://localhost:4646"
}

variable "aws_access_key_id" {
  description = "Auth details for AWS, should only be used in local mode"
  type = string
}

variable "aws_access_secret_key" {
  description = "Auth details for AWS, should only be used in local mode"
  type = string
}

variable "compiler_resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 4000,
    memory = 2048
  }
}

variable "controller_resources" {
  description = "The resource to assign to the application."
  type = object({
    cpu    = number
    memory = number
  })
  default = {
    cpu    = 500,
    memory = 256
  }
}
