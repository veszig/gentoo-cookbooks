#!/bin/bash

/bin/sed 's/^\s*command\[\([^\]*\)\].*$/\1/' /etc/nagios/nrpe.d/* | sort -n | \
  while read COMMAND ; do
    echo -n "${COMMAND}: "
    /usr/lib/nagios/plugins/check_nrpe -H 127.0.0.1 -c ${COMMAND}
  done
