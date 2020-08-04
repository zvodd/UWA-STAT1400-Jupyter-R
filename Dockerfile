FROM buildpack-deps:focal

ARG ANACONDA_FILE="Anaconda3-2020.07-Linux-x86_64.sh"
ARG ANACONDA_INSTALL_DIR="/opt/conda"

LABEL org.label-schema.description="Anaconda 3, Jupyter Notebook, and R for UWA Stat1400"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH $ANACONDA_INSTALL_DIR/bin:$PATH

USER root

RUN echo "APT-GET UPDATE" &&\
    apt-get update --fix-missing && apt-get install -y\
        wget \
        bzip2 \
        ca-certificates &&\
    echo "---------------------------------------------------------------------" &&\
    echo "Install Conda" &&\
    cd /tmp && \  
    wget -nv https://repo.anaconda.com/archive/$ANACONDA_FILE &&\
    chmod 755 $ANACONDA_FILE &&\
    ./$ANACONDA_FILE -b -p $ANACONDA_INSTALL_DIR &&\
    rm ./$ANACONDA_FILE && \
    ln -s $ANACONDA_INSTALL_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". $ANACONDA_INSTALL_DIR/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc &&\
    echo "---------------------------------------------------------------------" &&\
    echo "Installing Python and Jupyter Notebook ..." &&\
    apt-get install -y \
        python3.8 \
        python3.8-dev \
        python3-distutils \
        python3-widgetsnbextension \
        python3-testresources \
    jupyter-client &&\
    ln -s /usr/bin/python3 /usr/bin/python &&\
    echo "---------------------------------------------------------------------" &&\
    echo "Get pip" &&\
    cd /tmp && \
    wget https://bootstrap.pypa.io/get-pip.py &&\
    python3.8 get-pip.py &&\
    pip install \
        ipython \
        jupyter \
        jupyter_contrib_nbextensions\
        numpy \
        scipy \
        pandas \
        matplotlib \
        janome \
        pyper &&\
    echo "---------------------------------------------------------------------" &&\
    echo "Installing R and packages ..." &&\
    apt-get install -y \
        r-base-core &&\
        libczmq-dev \
        libcurl4-openssl-dev \
        libxml2 \
        libxml2-dev &&\
    R -e "install.packages(c('crayon', 'pbdZMQ', 'devtools', 'ggplot2'), repos = 'https://cran.rstudio.com/', dep = TRUE)" &&\
    R -e "devtools::install_github(paste0('IRkernel/', c('repr', 'IRdisplay', 'IRkernel')))" &&\
    R -e "IRkernel::installspec(user = FALSE)"
    