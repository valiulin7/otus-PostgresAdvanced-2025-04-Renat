#!/bin/bash

SG_ID=$(yc vpc security-group create \
  --name pg-dev-safe-sg \
  --network-name default \
  --format=json | jq -r .id)

yc vpc security-group update-rules $SG_ID \
  --add-rule "direction=ingress,port=6432,protocol=tcp,v4-cidrs=109.252.59.77/32" \
  --add-rule "direction=egress,from-port=0,to-port=65535,protocol=any,v4-cidrs=0.0.0.0/0"

yc compute instance list

yc managed-postgresql resource-preset list

yc managed-postgresql cluster create \
  --name pg-dev \
  --environment prestable \
  --network-name default \
  --host zone-id=ru-central1-a,subnet-name=default-ru-central1-a,assign-public-ip=true \
  --resource-preset b1.medium \
  --disk-size 10 \
  --disk-type network-hdd \
  --user name=dev_user,password='YourStrongPass123!' \
  --database name=devdb,owner=dev_user \
  --security-group-ids $SG_ID

yc managed-postgresql cluster list

# connect
mkdir -p ~/.postgresql && \
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
    --output-document ~/.postgresql/root.crt && \
chmod 0600 ~/.postgresql/root.crt

psql "host=rc1a-fuhfc2se9v3ulav2.mdb.yandexcloud.net \
    port=6432 \
    sslmode=verify-full \
    dbname=devdb \
    user=dev_user \
    target_session_attrs=read-write"

# autoscale
yc managed-postgresql cluster update pg-dev \
  --disk-size-autoscaling disk-size-limit=21474836480,emergency-usage-threshold=90

# add white ip
yc vpc security-group update-rules $SG_ID \
  --add-rule "direction=ingress,port=6432,protocol=tcp,v4-cidrs=109.252.59.78/32"

yc managed-postgresql cluster delete pg-dev