ARG FROM="ubuntu:14.04"

FROM ${FROM}

LABEL maintainer="Telegram Desktop (https://github.com/telegramdesktop/docker_linux_build)"
LABEL description="Build container for Telegram Desktop (Linux)"

ENV DEBIAN_FRONTEND=noninteractive
ENV TDESKTOP_BRANCH master

ARG MAKE_THREADS_CNT=-j8

WORKDIR /TBuild

RUN apt-get update && \
    apt-get install -qy software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    add-apt-repository -y ppa:george-edison55/cmake-3.x && \
    apt-get update && \
    apt-get install -qy gcc-7 g++-7 cmake && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 60 && \
    add-apt-repository -y --remove ppa:ubuntu-toolchain-r/test && \
    add-apt-repository -y --remove ppa:george-edison55/cmake-3.x

RUN apt-get update && \
    apt-get install -qy git libexif-dev liblzma-dev libz-dev libssl-dev libappindicator-dev libunity-dev libicu-dev libdee-dev libdrm-dev dh-autoreconf autoconf automake libass-dev libfreetype6-dev libgpac-dev libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-image0-dev libxcb-shm0-dev libxcb-xfixes0-dev libxcb-keysyms1-dev libxcb-icccm4-dev libxcb-render-util0-dev libxcb-util0-dev libxrender-dev libasound-dev libpulse-dev libxcb-sync0-dev libxcb-randr0-dev libx11-xcb-dev libffi-dev libncurses5-dev pkg-config texi2html zlib1g-dev yasm cmake xutils-dev bison python-xcbgen

RUN git clone --recursive https://github.com/telegramdesktop/tdesktop.git

WORKDIR /TBuild/Libraries

RUN git clone https://github.com/ericniebler/range-v3

RUN git clone https://github.com/telegramdesktop/zlib.git && \
    cd zlib && \
    ./configure && \
    make $MAKE_THREADS_CNT && \
    make install

RUN git clone https://github.com/xiph/opus && \
    cd opus && \
    git checkout v1.2.1 && \
    ./autogen.sh && \
    ./configure && \
    make $MAKE_THREADS_CNT && \
    make install

RUN git clone https://github.com/01org/libva.git && \
    cd libva && \
    ./autogen.sh --enable-static && \
    make $MAKE_THREADS_CNT && \
    make install

RUN git clone git://anongit.freedesktop.org/vdpau/libvdpau && \
    cd libvdpau && \
    ./autogen.sh --enable-static && \
    make $MAKE_THREADS_CNT && \
    sudo make install
