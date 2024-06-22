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
    vim

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
