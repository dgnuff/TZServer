FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN \
    echo "tzdata tzdata/Areas select US" > /tmp/preseed.cfg ; \
    echo "tzdata tzdata/Zones/US select Pacific" >> /tmp/preseed.cfg ; \
    debconf-set-selections /tmp/preseed.cfg ; \
    rm -f /etc/timezone /etc/localtime ; \
    apt update ; \
    apt install -y tzdata ; \
    apt install -y nodejs ; \
    rm -f /tmp/preseed.cfg ; \
    echo "#!/bin/bash" > /startup.sh ; \
    echo "cd /tzserver" >> /startup.sh ; \
    echo "node tzserver.js" >> /startup.sh ; \
    chmod 755 /startup.sh ; \
    mkdir /tzserver ; \
    true

ADD https://raw.githubusercontent.com/dgnuff/TZServer/2ffc7908d2220ebd61d6a6958c4c47ee476cbbea/tzserver.js tzserver/tzserver.js
ADD https://raw.githubusercontent.com/dgnuff/TZServer/2ffc7908d2220ebd61d6a6958c4c47ee476cbbea/tzinfo.js tzserver/tzinfo.js

# ENTRYPOINT [ "/startup.sh" ]
ENTRYPOINT [ "/bin/bash" ]
