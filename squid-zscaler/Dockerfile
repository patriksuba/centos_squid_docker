FROM centos

ENV SQUID_VERSION=4.4 \
    SQUID_CACHE_DIR=/var/spool/squid \
    SQUID_LOG_DIR=/var/log/squid \
    SQUID_USER=squid

RUN groupadd -g 1000 ${SQUID_USER} \
  && useradd -u 1000 ${SQUID_USER} -g 1000

# You will need the usual build chain
RUN yum install -y perl gcc autoconf automake make sudo wget libxml2-devel libcap-devel libtool-ltdl-devel curl bzip2 gcc-c++ patch which httpd-tools && \
  yum clean -y all

ADD ./Connection_Established.patch /tmp/
RUN curl -O http://www.squid-cache.org/Versions/v4/squid-4.4.tar.bz2 && tar -xvjf squid-4.4.tar.bz2 && cd squid-4.4 && \
  patch -p0 < /tmp/Connection_Established.patch && \
  ./configure \
  --prefix=/usr \
  --includedir=/usr/include \
  --datadir=/usr/share \
  --bindir=/usr/sbin \
  --libexecdir=/usr/lib/squid \
  --localstatedir=/var \
  --sysconfdir=/etc/squid && \
  make && \
  make install

ADD ./entrypoint.sh /sbin/
ADD ./squid-noauth.conf /etc/squid/squid-noauth.conf
ADD ./squid-auth.conf /etc/squid/squid-auth.conf

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
