#!/bin/bash
set -e

create_log_dir() {
  echo "Creating log directory: ${SQUID_LOG_DIR}"
  mkdir -p ${SQUID_LOG_DIR}
  chmod -R 755 ${SQUID_LOG_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_LOG_DIR}
}

create_cache_dir() {
  echo "Creating cache directory: ${SQUID_CACHE_DIR}"
  mkdir -p ${SQUID_CACHE_DIR}
  chown -R ${SQUID_USER}:${SQUID_USER} ${SQUID_CACHE_DIR}
}

create_log_dir
create_cache_dir

if [ ${AUTH} -eq 1 ];then
  echo "Create passwords file for squid"
  echo ${AUTH_PASSWORD:test123} | htpasswd -i -c /etc/squid/passwords ${AUTH_USER:insights}
  cp /etc/squid/squid-auth.conf /etc/squid/squid.conf
elif [ ${ICAP} -eq 1 ];then
  cp /etc/squid/squid-icap-noauth.conf /etc/squid/squid.conf
else
  cp /etc/squid/squid-noauth.conf /etc/squid/squid.conf
fi

# allow arguments to be passed to squid
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  if [[ ! -d ${SQUID_CACHE_DIR}/00 ]]; then
    echo "Initializing cache..."
    $(which squid) -N -f /etc/squid/squid.conf -z
  fi
  echo "Starting squid..."
  exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
