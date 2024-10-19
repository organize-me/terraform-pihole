FROM amazon/aws-cli:2.18.9

ENV PATH="/etc/backup/bin:$${PATH}"

RUN yum install -y zip unzip

VOLUME ${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_CONFIG}
VOLUME ${TF_VOLUME_DIR}/${TF_VOLUME_PIHOLE_DNSMASQ}

COPY backup.sh /etc/backup/bin/backup
RUN chmod +x /etc/backup/bin/backup

COPY restore.sh /etc/backup/bin/restore
RUN chmod +x /etc/backup/bin/restore

ENTRYPOINT ["/bin/sh", "-c"]
