variable "docker_host" {
  default = "unix:///var/run/docker.sock"
}

variable "docker_network" {
  type = string
  default = "organize_me_network"
}

variable "timezone" {
  type = string
  default = "America/Los_Angeles"
}

variable "pihole_image" {
  type = string
  default = "pihole/pihole:2024.07.0"
}

variable "backup_s3_bucket" {
  type = string
  default = "organize-me-backup"
}

variable "backup_install_path" {
  type = string
  default = "../bin"
}
