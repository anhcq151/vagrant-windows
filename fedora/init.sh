#!/usr/bin/env bash


SETETIMEDATE="/tmp/timedate.te"
SEMODTIMEDATE="/tmp/timedate.mod"
SEPPTIMEDATE="/tmp/timedate.pp"

dnf update -y
dnf install -y jq unzip bash-completion setroubleshoot policycoreutils policycoreutils-devel podman buildah

cat <<EOF > $SETETIMEDATE

module timedate 1.0;

require {
        type systemd_timedated_t;
        type etc_t;
        class lnk_file unlink;
}

#============= systemd_timedated_t ==============
allow systemd_timedated_t etc_t:lnk_file unlink;
EOF

checkmodule -Mmo $SEMODTIMEDATE $SETETIMEDATE
semodule_package -o $SEPPTIMEDATE -m $SEMODTIMEDATE
semodule -i $SEPPTIMEDATE
timedatectl set-timezone Asia/Ho_Chi_Minh

