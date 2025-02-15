# Build docker with
# docker build -t kinesis-video-producer-sdk-cpp-amazon-linux .
#
FROM amazonlinux:latest

RUN yum install -y \
	autoconf \
	automake  \
	bison \
	bzip2 \
	cmake \
	curl \
	diffutils \
	flex \
	gcc \
	gcc-c++ \
	git \
	gmp-devel \
	gstreamer* \
	libcurl-devel \
	libffi \
	libffi-devel \
	libmpc-devel \
	libtool \
	make \
	m4 \
	mpfr-devel \
	pkgconfig \
	vim \
	wget \
	xz && \
	wget https://cmake.org/files/v3.12/cmake-3.12.3.tar.gz && \
    tar zxvf cmake-3.* && \
    rm cmake-3.12.3.tar.gz && \
    cd cmake-3.12.3/ && \
    ./bootstrap && \
    make -j4 && \
    make install

WORKDIR /opt/
RUN git clone https://github.com/awslabs/amazon-kinesis-video-streams-producer-sdk-cpp.git
WORKDIR /opt/amazon-kinesis-video-streams-producer-sdk-cpp/build/
RUN cmake .. -DBUILD_GSTREAMER_PLUGIN=ON -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON && \
    make 

ENV LD_LIBRARY_PATH=/opt/amazon-kinesis-video-streams-producer-sdk-cpp/open-source/local/lib
ENV GST_PLUGIN_PATH=/opt/amazon-kinesis-video-streams-producer-sdk-cpp/build/:$GST_PLUGIN_PATH

RUN yum install -y \
  python3.9
