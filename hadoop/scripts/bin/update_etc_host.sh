#!/usr/bin/env bash
source ${DOCKER_CLUSTER_TOOLS_BIN_DIR}/docker_cluster_tools_lib.sh
log "[UPDATE_ETC_HOST][BEGIN]"
current_ip=$(hostname -i)
current_hostname=$(hostname -f)
log "[UPDATE_ETC_HOST][INFO] current_ip=[${current_ip}] current_hostname=[${current_hostname}]"

hosts_file="${DOCKER_CLUSTER_TOOLS_SHARED_CONF_DIR}/etc/hosts"

if [ ! -f "${hosts_file}" ]; then
 log "[UPDATE_ETC_HOST][WARNING] File ${hosts_file} don't exist. It will be created!"
 echo -e "127.0.0.1       localhost
::1     localhost ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
" > ${hosts_file}
fi

sed -i "/${current_hostname}/d" ${hosts_file}
sed -i "/${current_ip}/d" ${hosts_file}
echo -e "${current_ip} ${current_hostname}" >>  ${hosts_file}
log "[UPDATE_ETC_HOST][INFO] Update File ${hosts_file} done."
log "[UPDATE_ETC_HOST][END]"
