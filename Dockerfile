# sudo docker build --tag hera
FROM ubuntu

# update catalogs
RUN apt update

# install requirements
RUN apt install -y bash make coreutils findutils cpio

# instalation the tool
WORKDIR /tmp/hera
COPY . .
RUN make install

# switch home
WORKDIR /root

# shell
ENTRYPOINT /bin/bash