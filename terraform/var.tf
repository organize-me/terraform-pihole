# General Variables
variable "timezone" {
  type = string
  default = "America/Los_Angeles"
}

# Docker Variables
variable "docker_host" {
  default = "unix:///var/run/docker.sock"
}
variable "docker_network" {
  type = string
}

# Pi-hole Variables
variable "pihole_image" {
  type = string
  default = "pihole/pihole:2024.07.0"
}

# Backup Variables
variable "backup_s3_bucket" {
  description = "S3 bucket to store the backups"
  type = string
}
variable "backup_install_path" {
  description = "Path to install the backup scripts"
  type = string
  default = "../bin"
}
variable "backup_tmp_dir" {
  description = "Temporary directory to store the backup archive"
  type = string
  default = "../tmp"
}
variable "backup_archive_name" {
  description = "Name of the backup archive"
  type = string
  default = "pihole-backup.tar.gz"
}

# AWS Variables
variable "aws_cli_image" {
  description = "Docker image for the AWS CLI"
  type = string
  default = "amazon/aws-cli:2.18.9"
}
