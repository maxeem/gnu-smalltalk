# Use the official Rocky Linux 8 image as the base
FROM rockylinux:8

# Install necessary packages
RUN dnf update -y && \
    dnf install -y \
    git \
    gcc \
    gcc-c++ \
    make \
    libtool \
    bison \
    flex \
    gmp-devel \
    libffi-devel \
    libsigsegv-devel \
    autoconf \
    automake \
    libtool-ltdl-devel \
    texinfo \
    vim \
    gtk2-devel \
    sqlite-devel \
    SDL-devel SDL-static SDL_gfx SDL_gfx-devel SDL_image SDL_image-devel \
    SDL_net SDL_net-devel SDL_sound SDL_sound-devel SDL_ttf SDL_ttf-devel

# Clone the GNU Smalltalk repository
RUN git clone https://github.com/maxeem/gnu-smalltalk.git

# Set the working directory
WORKDIR /gnu-smalltalk

# Generate the configure script
RUN autoreconf -i

# Configure the build
RUN ./configure

# Compile GNU Smalltalk
RUN make

# Install GNU Smalltalk
RUN make install

# Set the LD_LIBRARY_PATH environment variable
ENV LD_LIBRARY_PATH /usr/local/lib/smalltalk

# Set the entrypoint to gst
ENTRYPOINT ["gst"]
