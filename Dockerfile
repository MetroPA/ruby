FROM ruby:2.3.7-stretch

### Remove unused MySQL configs ###
RUN rm -rf /etc/mysql

### Patch OpenSSL ###
RUN echo 'deb http://ftp.debian.org/debian stretch-backports main' > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get -t stretch-backports install -y openssl perl

# Install imagemagick, wkhtmltopdf, and dependencies.
RUN apt-get install -y imagemagick xvfb libfontconfig

# Install most up-to-date FreeTDS
RUN apt-get purge -y freetds-dev freetds-bin freetds-common && \
  rm -f /usr/bin/tsql && \
  apt-get install -y  libc6-dev && \
  wget http://www.freetds.org/files/stable/freetds-1.00.tar.gz \
  && tar -xvf freetds-1.00.tar.gz \
  && cd freetds-1.00 \
  && ./configure --prefix=/usr --with-tdsver=7.3 \
  && make \
  && make install

EXPOSE 8080

ENV PORT 8080
