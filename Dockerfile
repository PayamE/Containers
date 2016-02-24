FROM ubuntu:14.04

RUN apt-get update && apt-get install cmake g++ autoconf qt4-dev-tools patch libtool make git --yes
RUN    apt-get install libboost-regex-dev libboost-iostreams-dev libboost-date-time-dev libboost-math-dev \
      libsvm-dev libglpk-dev libzip-dev zlib1g-dev libxerces-c-dev libbz2-dev --yes
RUN git clone https://github.com/OpenMS/OpenMS.git 
RUN git clone  https://github.com/OpenMS/contrib.git 
RUN mkdir contrib-build 
RUN cd /contrib-build && \
#RUN pwd
#RUN OUTPUT="$(pwd)"
cmake -DBUILD_TYPE=LIST ../contrib && \
cmake -DBUILD_TYPE=SEQAN ../contrib && \
cmake -DBUILD_TYPE=WILDMAGIC ../contrib && \
cmake -DBUILD_TYPE=EIGEN ../contrib
#RUN cd ..
RUN mkdir OpenMS-build
RUN cd OpenMS-build && \
cmake -DCMAKE_PREFIX_PATH="/contrib-build;/usr;/usr/local" -DBOOST_USE_STATIC=OFF ../OpenMS && \
make FileInfo
ENV LD_LIBRARY_PATH /OpenMS-build/lib:$LD_LIBRARY_PATH
ENV PATH $PATH:/OpenMS-build/bin
RUN echo $PATH
MAINTAINER Payam Emami, payam.emami@medsci.uu.se
ENTRYPOINT ["FileInfo"]

