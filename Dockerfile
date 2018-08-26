FROM debian:7

RUN apt-get update && \
	apt-get install -y --no-install-recommends libgcrypt-dev libmysqld-dev build-essential curl unzip bison byacc && \
	mkdir -p /mud/game/bin && mkdir -p /mud/game/lib

ADD configure.sh /tmp/configure.sh
ADD gomud /mud/game/bin/gomud

RUN curl -o /tmp/ldmud.zip -k https://codeload.github.com/ldmud/ldmud/legacy.zip/master-3.3
RUN unzip /tmp/ldmud.zip -d /tmp
RUN cd /tmp/ldmud*/src && /tmp/configure.sh
RUN cd /tmp/ldmud*/src && make install
RUN cd /tmp/ldmud*/src && make install-utils

EXPOSE 5005 5000 5110 5025 4999 4998 4997 4996 4995 5050/udp

VOLUME /mud/game/lib

CMD [ "/mud/game/bin/gomud" ]

# Testing run
# docker run --rm -i -t -v /Users/daryth/Downloads/home/daryth/tauros/game/lib:/mud/game/lib -p 5000:5000 -p 5050:5050/udp emcconkey/ldmud-tauros bash
# Production run
# docker run --name taurosmud -d -v /Users/daryth/Downloads/home/daryth/tauros/game/lib:/mud/game/lib -p 5000:5000 -p 5005:5005 -p 5050:5050/udp emcconkey/ldmud-tauros

