FROM centos

ENV SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid

RUN groupadd -g 1000 ${SQUID_USER} \
  && useradd -u 1000 ${SQUID_USER} -g 1000

# You will need the usual build chain
RUN yum install -y squid which httpd-tools && \
  yum clean -y all

ADD ./entrypoint.sh /sbin/
ADD ./squid-noauth.conf /etc/squid/squid-noauth.conf
ADD ./squid-auth.conf /etc/squid/squid-auth.conf
ADD ./squid-icap-noauth.conf /etc/squid/squid-icap-noauth.conf

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
