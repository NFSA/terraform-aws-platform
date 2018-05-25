#cloud-config
package_upgrade: false
runcmd:
- sed -i 's/^log_group_name = .*/log_group_name = ${services_log_group}/' /var/awslogs/etc/awslogs.conf
- systemctl restart awslogs
- /opt/graymeta/bin/aws_configurator -bucket ${file_storage_s3_bucket_arn} -usage-bucket ${usage_s3_bucket_arn} -region ${region} -encrypted-config-blob "${encrypted_config_blob}" >> /etc/graymeta/metafarm.env 2>/var/log/graymeta/aws_configurator.log
- systemctl daemon-reload
- systemctl restart docker-facebox.service
- /opt/graymeta/bin/all-services.sh restart
write_files:
-   content: |
        [Unit]
        Description=Daemon for facebox
        After=docker.service
        Wants=
        Requires=docker.service
        [Service]
        Restart=on-failure
        StartLimitInterval=20
        StartLimitBurst=5
        TimeoutStartSec=0
        Environment="HOME=/root"
        ExecStartPre=-/usr/bin/docker kill facebox
        ExecStartPre=-/usr/bin/docker rm  facebox
        ExecStart=/usr/bin/docker run \
            --net bridge \
            -m 0b \
            -e MB_KEY=${facebox_key} \
            -e MB_FACEBOX_REDIS=${elasticache_facebox}:6379 \
            -e MB_FACEBOX_REDIS_DB=0 \
            -p 9090:8080  \
            --name facebox \
            machinebox/facebox
        ExecStop=-/usr/bin/docker stop --time=0 facebox
        ExecStop=-/usr/bin/docker rm  facebox
        [Install]
        WantedBy=multi-user.target
    path: /etc/systemd/system/docker-facebox.service
    permissions: '0644'
-   content: |
        PATH=/opt/graymeta/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
        SES_REGION=${region}
        box_client_id=${box_client_id}
        box_client_secret=${box_client_secret}
        facebox_host=http://127.0.0.1:9090
        gm_auth_api_redis=${elasticache_services}:6379
        gm_auth_api_redis_db=0
        gm_auth_api_redis_key_prefix="authapi:"
        gm_base_url=https://${dns_name}
        gm_completed_sns_topic_arn=${sns_topic_arn_harvest_complete}
        gm_container_image=graymeta/harvester
        gm_data_api=https://${dns_name}/api/data
        gm_db_host=${db_endpoint}
        gm_db_name=graymeta
        gm_db_password=${db_password}
        gm_db_port=5432
        gm_db_username=${db_username}
        gm_ecs_auth_type=iam
        gm_ecs_cluster=${ecs_cluster}
        gm_ecs_cpu=1024
        gm_ecs_log_group=${ecs_log_group}
        gm_ecs_memory_hard=4000
        gm_ecs_memory_soft=3000
        gm_ecs_region=${region}
        gm_elasticsearch=${elasticsearch_endpoint}
        gm_email_from=${from_addr}
        gm_email_sender=ses
        gm_encryption_key=${encryption_key}
        gm_env=${gm_env}
        gm_fileapi_stow_kind=s3
        gm_files_api=https://${dns_name}/files
        gm_front_end_client_secret=${client_secret_fe}
        gm_google_maps_key=${google_maps_key}
        gm_harvest_polling_time=${harvest_polling_time}
        gm_internal_client_secret=${client_secret_internal}
        gm_job_store_redis=${elasticache_services}:6379
        gm_job_store_redis_db=0
        gm_job_store_redis_key_prefix="jobinfo:"
        gm_jwt_private_key=${jwt_key}
        gm_recently_walked_expiration=1209600s
        gm_recently_walked_redis=${elasticache_services}:6379
        gm_recently_walked_redis_db=0
        gm_recently_walked_redis_key_prefix="recwalked:"
        gm_scheduler_api=https://${dns_name}/api/scheduler
        gm_sqs_activity=${sqs_activity}
        gm_sqs_index=${sqs_index}
        gm_sqs_stage=${sqs_stage}
        gm_sqs_walk=${sqs_walk}
        gm_usage_api=https://${dns_name}/api/usage
        gm_usage_prefix=${gm_usage_prefix}
        harvest_facebox_host=https://${dns_name}:8445
        harvest_gm_temp_bucket_name=${temporary_bucket_name}
        harvest_gm_temp_bucket_region=${region}
        harvest_magic_files=/etc/magic:/usr/share/misc/magic:/etc/graymeta/mime.magic
        harvest_rollbar_token=${rollbar_token}
        rollbar_token=${rollbar_token}
        stow_mountpath=/var/lib/graymeta/mounts
    path: /etc/graymeta/metafarm.env
    permissions: '0400'
    owner: graymeta:graymeta
-   content: |
        [plugins]
        cwlogs = cwlogs
        [default]
        region = ${region}
    path: /var/awslogs/etc/aws.conf
