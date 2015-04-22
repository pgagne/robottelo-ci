pip install -U -r requirements.txt

source ${SUBSCRIPTION_CONFIG}

if [ ${FIX_HOSTNAME} = "true" ]; then
    fab -i ~/.ssh/id_hudson_dsa -H root@${SERVER_HOSTNAME} fix_hostname
fi

if [ ${PARTITION_DISK} = "true" ]; then
    fab -i ~/.ssh/id_hudson_dsa -H root@${SERVER_HOSTNAME} partition_disk
fi

# Figure out what version of RHEL the server uses
OS_VERSION=$(fab -i ~/.ssh/id_hudson_dsa -H root@${SERVER_HOSTNAME} distro_info | grep "rhel [[:digit:]]" | cut -d ' ' -f 2)
export ADMIN_EMAIL="root@localhost"
export RHN_PROFILE="robottelo_${SERVER_HOSTNAME}"
export SSL_PASSWORD=reset
export SSL_SET_ORG="Red Hat"
export SSL_SET_ORG_UNIT="Satellite QE"
export SSL_SET_CITY="Brno"
export SSL_SET_STATE="BRQ"
export SSL_SET_COUNTRY="CZ"

if [ ${DISTRIBUTION} = "RELEASED" ]; then
    export ISO_URL="http://download/released/Satellite-${VERSION}-RHEL-${OS_VERSION}/x86_64/ftp-isos/"
fi

if [ ${DISTRIBUTION} = "CANDIDATE" ]; then
    export ISO_URL="http://download/devel/candidates/latest-link-Satellite-5.7.0-RHEL${OS_VERSION}-x86_64/iso/"
fi

fab -i ~/.ssh/id_hudson_dsa -H root@${SERVER_HOSTNAME} product_install:satellite5-iso
