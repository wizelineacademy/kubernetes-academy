FROM google/cloud-sdk

COPY service-account.json service-account.json

RUN apt-get update && apt-get install -y mysql-client && rm -rf /var/lib/apt
