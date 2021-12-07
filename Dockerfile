ARG FSDA_RELEASE=2021b
ARG DOCKER_TAG=r${FSDA_RELEASE}
FROM mathworks/matlab:$DOCKER_TAG
ARG FSDA_RELEASE
ARG MATLAB_RELEASE=R${FSDA_RELEASE}

USER root
WORKDIR /root

ARG RELEASE=R2021b
RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends --yes wget && \
    apt-get clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && \
    chmod +x mpm && \
    ./mpm install --destination=/opt/matlab/${MATLAB_RELEASE}/ --release=${MATLAB_RELEASE} \
        Statistics_and_Machine_Learning_Toolbox && \
    rm -f mpm

RUN mkdir /opt/fsda/ && \
    cd /opt/fsda/ && \
    wget -q https://github.com/UniprJRC/FSDA/archive/refs/tags/${FSDA_RELEASE}.tar.gz && \
    tar -xvzf ${FSDA_RELEASE}.tar.gz  && \
    rm ${FSDA_RELEASE}.tar.gz && \
    cd FSDA-${FSDA_RELEASE} && \
    rm -rf .github circleci _* 

RUN cp -r /opt/fsda/FSDA-${FSDA_RELEASE}/helpfiles/FSDA /opt/matlab/${MATLAB_RELEASE}/help/FSDA

USER matlab
WORKDIR /home/matlab