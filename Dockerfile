ARG FSDA_RELEASE=2021b
ARG DOCKER_TAG=r${FSDA_RELEASE}

FROM mathworks/matlab:$DOCKER_TAG
ARG FSDA_RELEASE
ARG MATLAB_RELEASE=R${FSDA_RELEASE}

USER root
WORKDIR /root

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends --yes wget && \
    apt-get clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*

RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && \
    chmod +x mpm && \
    ./mpm install --destination=/opt/matlab/${MATLAB_RELEASE}/ --release=${MATLAB_RELEASE} \
        Statistics_and_Machine_Learning_Toolbox \
        Parallel_Computing_Toolbox \ 
        MATLAB_Coder \
        Optimization_Toolbox && \
    rm -f mpm

RUN mkdir /opt/fsda/ && \
    cd /opt/fsda/ && \
    wget -q https://github.com/UniprJRC/FSDA/archive/refs/tags/${FSDA_RELEASE}.tar.gz && \
    tar -xzf ${FSDA_RELEASE}.tar.gz  && \
    rm ${FSDA_RELEASE}.tar.gz && \
    cd FSDA-${FSDA_RELEASE} && \
    rm -rf .github circleci _* 

# TODO - consider if this is an mv rather than a cp?
RUN cp -r /opt/fsda/FSDA-${FSDA_RELEASE}/helpfiles/FSDA /opt/matlab/${MATLAB_RELEASE}/help/FSDA

# One time startup.m that undertakes installation etc. of FSDA in MATLAB
COPY startup.m /opt/matlab/${MATLAB_RELEASE}/toolbox/local

USER matlab
WORKDIR /home/matlab