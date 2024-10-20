
resource "docker_image" "aws_cli" {
  name = var.aws_cli_image
}

# Script to run the backup script as a Docker container
resource "local_file" "run_backup" {
  filename = "${var.backup_install_path}/pihole-backup.sh"
  content = templatefile("./backup/pihole-backup.tf.sh", {
    TF_ARCHIVE_NAME          = var.backup_archive_name
    TF_S3_BACKUP_BUCKET      = var.backup_s3_bucket
    TF_AWS_CLI_IMAGE         = docker_image.aws_cli.name
    TF_PIHOLE_CONTAINER      = docker_container.pihole.name
    TF_BACKUP_TMP_DIR        = abspath(var.backup_tmp_dir)
  })
}

# Make the backup script executable
resource "null_resource" "run_backup_exec" {
  provisioner "local-exec" {
    command = "chmod +x ${local_file.run_backup.filename}"
  }

  triggers = {
    md5 = local_file.run_backup.content_md5
  }

  depends_on = [local_file.run_backup]
}

# Script to run the restore script as a Docker container
resource "local_file" "run_restore" {
  filename = "${var.backup_install_path}/pihole-restore.sh"
  content = templatefile("./backup/pihole-restore.tf.sh", {
    TF_VOLUME_PIHOLE_CONFIG  = docker_volume.pihole_config.name
    TF_VOLUME_PIHOLE_DNSMASQ = docker_volume.pihole_dnsmasq.name
    TF_S3_BACKUP_BUCKET      = var.backup_s3_bucket
    TF_AWS_CLI_IMAGE         = docker_image.aws_cli.name
    TF_PIHOLE_CONTAINER      = docker_container.pihole.name
  })
}

# Make the restore script executable
resource "null_resource" "run_restore_exec" {
  provisioner "local-exec" {
    command = "chmod +x ${local_file.run_restore.filename}"
  }

  triggers = {
    md5 = local_file.run_restore.content_md5
  }

  depends_on = [local_file.run_restore]
}
