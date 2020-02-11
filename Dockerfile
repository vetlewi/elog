FROM gcc:latest
RUN apt-get -qq update && apt-get -y -qq install cmake && apt-get -y -qq install emacs
RUN git clone --quiet https://ritt@bitbucket.org/ritt/elog.git
WORKDIR /elog
RUN git submodule update --init
RUN mkdir build && cd build && cmake .. && make
RUN ls -l build
