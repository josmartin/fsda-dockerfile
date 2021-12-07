FROM mathworks/matlab:r2021b

USER root
WORKDIR /root

ARG RELEASE=R2021b
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends --yes wget && \
    apt-get clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && \
    chmod +x mpm && \
    ./mpm install --destination=/opt/matlab/${RELEASE}/ --release=${RELEASE} \
        Statistics_and_Machine_Learning_Toolbox && \
    rm -f mpm

RUN mkdir /opt/fsda/ && \
    cd /opt/fsda/ && \
    wget -q https://github.com/UniprJRC/FSDA/archive/refs/tags/2021b.tar.gz && \
    tar -xvzf 2021b.tar.gz  && \
    rm 2021b.tar.gz && \
    cd FSDA-2021b && \
    rm -rf .github circleci _* 

RUN cp -r /opt/fsda/FSDA-2021b/helpfiles/FSDA /opt/matlab/R2021b/help/FSDA

USER matlab
WORKDIR /home/matlab