resource "docker_image" "pihole" {
  name = "pihole/pihole:2024.07.0"
  keep_locally = true
}

# Create a volume for the pihole configuration
resource "docker_volume" "pihole_config" {
  name = "pihole_config"
}

# Create a volume for the dnsmasq configuration
resource "docker_volume" "dnsmasq_config" {
  name = "dnsmasq_config"
}

resource "docker_container" "pihole" {
  image    = docker_image.pihole.image_id
  name     = "organize-me-pihole"
  hostname = "pihole"
  restart  = "unless-stopped"
  network_mode = "bridge"
  wait         = true

  env = [
    "TZ=${var.timezone}",
    "WEBPASSWORD="
  ]
  volumes {
    container_path = "/etc/pihole"
    volume_name    = docker_volume.pihole_config.name
    read_only      = false
  }
  volumes {
    container_path = "/etc/dnsmasq.d"
    volume_name    = docker_volume.dnsmasq_config.name
    read_only      = false
  }
  networks_advanced {
    name    = data.docker_network.network.name
    aliases = ["pihole"]
  }
  ports {
    internal = 53
    external = 53
    protocol = "tcp"
  }
  ports {
    internal = 53
    external = 53
    protocol = "udp"
  }
  ports {
    internal = 67
    external = 67
    protocol = "udp"
  }
  capabilities {
    add = ["NET_ADMIN"]
  }
}
