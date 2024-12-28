FROM debian:bookworm AS build

RUN apt-get update && \
    apt-get install -y curl \
        git build-essential cmake \
        libasound2-dev pkg-config \
        zlib1g-dev

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin/:${PATH}"

RUN mkdir /build
ENV CARGO_TARGET_DIR=/build
ENV CARGO_HOME=/build/cache

RUN git clone https://github.com/librespot-org/librespot.git /src
WORKDIR /src
RUN cargo build --release --no-default-features --features "alsa-backend"

FROM debian:bookworm
RUN apt-get update && \
    apt-get install -y libasound2 mpc && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 4070
RUN mkdir /librespot
COPY --from=build /build/release/librespot /librespot/
COPY librespot_avahi.service /librespot/librespot_avahi.service
COPY start.sh /librespot/start.sh
COPY mpc_stop.sh /librespot/mpc_stop.sh
ENTRYPOINT ["/librespot/start.sh"]
