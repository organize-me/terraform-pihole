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
  type = string
}
variable "backup_install_path" {
  type = string
}
