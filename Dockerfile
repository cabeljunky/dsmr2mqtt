FROM debian:buster-slim AS builder

RUN apt-get update && \
    apt-get install --no-install-recommends -y libmosquitto-dev build-essential git ca-certificates ragel
COPY . /usr/src/dsmr2mqtt
WORKDIR /usr/src/dsmr2mqtt
RUN git submodule init  && \
    git submodule update --recursive && \
    cd dsmr2mqtt && \
    make all
    
FROM debian:buster-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y libmosquitto1 ca-certificates && \
    apt-get clean && \
    useradd --group users --groups dialout --shell /bin/false --no-create-home dsrm2mqtt 
    
USER dsrm2mqtt

COPY --from=builder /usr/src/dsmr2mqtt/dsmr2mqtt/dsmr2mqtt /usr/bin/dsmr2mqtt
COPY scripts/entrypoint.sh entrypoint.sh

ENTRYPOINT [ "sh", "entrypoint.sh" ]
