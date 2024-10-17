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

