FROM debian:latest

RUN apt-get update && \
	apt-get install -y --no-install-recommends libgcrypt-dev libmysqld-dev build-essential curl wget unzip bison byacc && \
	mkdir -p /mud/game/bin && mkdir -p /mud/game/lib

ADD configure.sh /tmp/configure.sh
ADD gomud /mud/game/bin/gomud

RUN wget --no-check-certificate -O /tmp/ldmud.zip https://github.com/ldmud/ldmud/archive/refs/heads/master-3.5.zip
RUN unzip /tmp/ldmud.zip -d /tmp
RUN cd /tmp/ldmud*/src && cp ../autoconf/* . && /tmp/configure.sh
RUN cd /tmp/ldmud*/src && make install
RUN cd /tmp/ldmud*/src && make install-utils

EXPOSE 5005 5000 5110 5025 4999 4998 4997 4996 4995 5050/udp

VOLUME /mud/game/lib

CMD [ "/mud/game/bin/gomud" ]

# Testing run
# docker run --rm -i -t -v /Users/daryth/Downloads/home/daryth/tauros/game/lib:/mud/game/lib -p 5000:5000 -p 5050:5050/udp emcconkey/ldmud-tauros bash
# Production run
# docker run --name taurosmud -d -v /Users/daryth/Downloads/home/daryth/tauros/game/lib:/mud/game/lib -p 5000:5000 -p 5005:5005 -p 5050:5050/udp emcconkey/ldmud-tauros

