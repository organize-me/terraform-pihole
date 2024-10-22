
resource "docker_image" "minio" {
  name = "minio/minio:latest"
}

resource "docker_container" "minio" {
  name  = "minio"
  image = docker_image.minio.image_id
  network_mode = "bridge"
  wait = true

  healthcheck {
    test = ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
    interval = "30s"
    timeout = "10s"
    retries = 3
  }

  env = [
    "MINIO_ROOT_USER=${var.minio_root_user}",
    "MINIO_ROOT_PASSWORD=${var.minio_root_password}",
  ]

  ports {
    internal = 9000
    external = 9000
  }
  ports {
    internal = 9001
    external = 9001
  }

  command = ["server", "--address", ":9000", "/data"]

  depends_on = [docker_network.test_network]
}

resource "null_resource" "create_bucket" {
    triggers = {
        always_run = docker_container.minio.id
    }

    provisioner "local-exec" {
        command = <<EOF
        docker exec minio sh -c "mc alias set minio http://localhost:9000 ${var.minio_root_user} ${var.minio_root_password}"
        docker exec minio sh -c "mc mb minio/${var.backup_s3_bucket}"
        EOF
    }

    depends_on = [docker_container.minio]
}