FROM appsvc/rubybase:2.3.3
MAINTAINER Azure App Services Container Images <appsvc-images@microsoft.com>

COPY init_container.sh /bin/
COPY startup.sh /opt/
COPY sshd_config /etc/ssh/
COPY hostingstart.html /home/site/wwwroot/hostingstart.html
COPY staticsite.rb /opt/staticsite.rb

RUN apt-get update -qq

# Install imagemagick and dependencies.
RUN apt-get install -y imagemagick

# Install wkhtmltopdf dependencies.
RUN apt-get install -y xvfb libfontconfig

RUN apt-get install -y nodejs openssh-server vim curl wget tcptraceroute --no-install-recommends \
    && echo "root:Docker!" | chpasswd \
    && echo "cd /home" >> /etc/bash.bashrc

RUN apt-get purge -y freetds-dev freetds-bin freetds-common && \
  apt-get install -y  libc6-dev && \
  wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.86.tar.gz \
  && tar -xvf freetds-1.00.86.tar.gz \
  && cd freetds-1.00.86 \
  && ./configure --prefix=/usr/local --with-tdsver=7.3 \
  && make \
  && make install

RUN eval "$(rbenv init -)" \
  && rbenv global 2.3.3

RUN chmod 755 /bin/init_container.sh \
  && mkdir -p /home/LogFiles/ \
  && chmod 755 /opt/startup.sh

EXPOSE 2222 8080

ENV PORT 8080
ENV WEBSITE_ROLE_INSTANCE_ID localRoleInstance
ENV WEBSITE_INSTANCE_ID localInstance
ENV PATH ${PATH}:/home/site/wwwroot

WORKDIR /home/site/wwwroot

ENTRYPOINT [ "/bin/init_container.sh" ]
