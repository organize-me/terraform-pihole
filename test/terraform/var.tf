# Docker Variables
variable "docker_host" {
  default = "unix:///var/run/docker.sock"
}

variable "minio_root_user" {
  description = "Minio Root User"
  type = string
}

variable "minio_root_password" {
  description = "Minio Root Password"
  type = string
}

variable "backup_s3_bucket" {
  description = "S3 bucket to store the backups"
  type = string
}

variable "docker_network" {
  description = "Docker network name"
  type = string
}