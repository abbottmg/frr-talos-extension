FROM frrouting/frr:v8.4.1 as base
RUN apk add --no-cache --update-cache tcpdump gettext py3-pip curl lldpd iputils bind-tools busybox-extras mtr lshw jq
RUN pip3 install j2cli
COPY env.sh /etc/frr/env.sh
COPY docker-start.j2 /usr/lib/frr/docker-start.j2
COPY daemons /etc/frr/daemons
COPY frr.conf.j2 /etc/frr/frr.conf.j2
RUN source /etc/frr/env.sh && j2 -o /usr/lib/frr/docker-start /usr/lib/frr/docker-start.j2
COPY frr.yaml /

FROM scratch AS frr
COPY --from=base / /rootfs/usr/local/lib/containers/frr
COPY manifest.yaml /manifest.yaml
#COPY manifest.json /manifest.json
