FROM ubuntu:24.04

LABEL maintainer="eng.maksim@gmail.com"
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt update && apt install -y \
  build-essential \
  autoconf \
  libsigsegv-dev \
  gawk \
  automake \
  libtool \
  pkg-config \
  libglib2.0-dev \
  libgtk2.0-dev \
  texinfo \
  help2man \
  perl \
  git \
  make \
  emacs \
  wine \
  wget \
  zip \
  flex \
  bison \
  unzip \
  gettext \
  sed

RUN apt-get install -y \
  libgnutls28-dev libreadline-dev libgdbm-dev libsqlite3-dev libpq-dev \
  tcl-dev tk-dev libncurses-dev libgmp-dev \
  libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev libsdl-sound1.2-dev \
  libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libgirepository1.0-dev \
  binutils texinfo tcl vim && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /opt/gnusmalltalk

# Clone GNU Smalltalk source
RUN git clone https://github.com/maxeem/gnu-smalltalk.git .
# Patch broken AC_REQUIRE usage in macros
RUN aclocal -I build-aux && autoconf
RUN cd snprintfv && autoreconf -fi
RUN libtoolize --force --copy \
 && autoheader \
 && aclocal \
 && autoconf \
 && automake --add-missing --copy \
 && env CC=gcc ./configure --prefix=/usr/local --with-lispstartdir=/etc/emacs/site-start.d

RUN make all install -k || true

# Optional: Run tests
WORKDIR /opt/gnusmalltalk
RUN make check || echo "Some tests may fail in containerized environments"

# Add GUI remoting Support 
RUN apt install -y xvfb tk

# Default shell
CMD ["gst"]
