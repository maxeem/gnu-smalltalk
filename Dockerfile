# Author: Maksim Abuajamieh
# Stage 1: Build GNU Smalltalk
FROM ubuntu:24.04 AS builder

LABEL maintainer="eng.maksim@gmail.com"
ENV DEBIAN_FRONTEND=noninteractive

# Install build dependencies
RUN apt update && apt install -y --no-install-recommends \
  build-essential autoconf libsigsegv-dev gawk automake libtool pkg-config \
  libglib2.0-dev libgtk2.0-dev texinfo help2man perl git make emacs wine wget \
  zip flex bison unzip gettext sed libltdl-dev \
  libgnutls28-dev libreadline-dev libgdbm-dev libsqlite3-dev libpq-dev \
  tcl-dev tk-dev libncurses-dev libgmp-dev \
  libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev libsdl-sound1.2-dev \
  libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev libgirepository1.0-dev \
  binutils vim && rm -rf /var/lib/apt/lists/*

# Clone GNU Smalltalk source
WORKDIR /opt/gnusmalltalk
RUN apt update && apt install -y --no-install-recommends ca-certificates
RUN git clone https://github.com/maxeem/gnu-smalltalk.git .

# Filter out glib/gwin32.h from mkorder.awk input
RUN awk '{ \
  if ($0 ~ /function process_file/) in_func = 1; \
  if (in_func && $0 ~ /file = find_file/) \
    print "    if (name == \"glib/gwin32.h\") return; # skip Windows-only header"; \
  print \
}' packages/gtk/mkorder.awk > patched.awk && mv patched.awk packages/gtk/mkorder.awk

# Regenerate build system
RUN aclocal -I build-aux && autoconf
RUN cd snprintfv && autoreconf -fi
RUN libtoolize --force --copy \
 && autoheader \
 && aclocal \
 && autoconf \
 && automake --add-missing --copy \
 && env CC=gcc ./configure --prefix=/usr/local --with-lispstartdir=/etc/emacs/site-start.d

# Build and install
RUN make && make install

# Optional: strip debug symbols
RUN strip /usr/local/bin/gst || true

# Stage 2: Runtime image
FROM ubuntu:24.04

LABEL maintainer="eng.maksim@gmail.com"
ENV DEBIAN_FRONTEND=noninteractive

# Install only runtime dependencies
RUN apt update && apt install -y --no-install-recommends \
  libsigsegv-dev libreadline-dev libgdbm-dev libsqlite3-dev libpq-dev \
  libglib2.0-0 libgtk2.0-0 libgnutls30 libgmp10 \
  libsdl1.2debian libsdl-image1.2 libsdl-mixer1.2 libsdl-ttf2.0-0 libsdl-sound1.2 \
  libgl1 libglu1 libgirepository-1.0-1 libltdl-dev \
  tcl tk libncurses6 && rm -rf /var/lib/apt/lists/*

# Copy compiled binaries from builder
COPY --from=builder /usr/local /usr/local

# Optional: copy examples or wrapper scripts
WORKDIR /scripts
COPY --from=builder /opt/gnusmalltalk/examples ./examples

# Default command
CMD ["gst"]
