pip install -r requirements.txt
source ${CONFIG_FILES}
source config/fake_manifest.conf
source config/subscription_config.conf
export EXP_SUBS_FILE=config/robottelo-manifest-content.conf
fab -D -H "root@${MANIFEST_SERVER_HOSTNAME}" relink_manifest
