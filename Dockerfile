## 
## SEE : 
##   jupyter/base-notebook @ https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html
##
FROM jupyter/base-notebook:latest AS NOTEBOOK_SETUP 
#
#RUN conda install -c conda-forge cxx-compiler vim 
#RUN conda install -c anaconda make cmake 
#
RUN apt-get --yes -qq update 
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get -y install tzdata
RUN apt-get --yes -qq update 

RUN apt-get --yes -qq install wget xz-utils
RUN apt-get --yes -qq install build-essential  
RUN apt-get --yes -qq install gcc g++  
RUN apt-get --yes -qq install cmake 
RUN apt-get --yes -qq install cmake-curses-gui ## ccmake 
RUN apt-get --yes -qq install clang-tools-9
RUN apt-get --yes -qq install python3

RUN apt-get --yes -qq install libx11-dev
RUN apt-get --yes -qq install libglu1-mesa-dev
RUN apt-get --yes -qq install libxdamage1
RUN apt-get --yes -qq install libxt6 
RUN apt-get --yes -qq install libxxf86vm-dev -y

#RUN apt-get --yes -qq install 
RUN apt-get --yes -qq clean
RUN rm -rf /var/lib/apt/lists/*


FROM NOTEBOOK_SETUP AS NOTEBOOK_EXECUTE
ENV IPYNB_FILE="nvcc_ubuntufocal.ipynb"
ENV NB_USER="jovyan" 
USER root 
WORKDIR /home/jovyan/work 
COPY ${IPYNB_FILE} /home/jovyan/work 
RUN chown -R ${NB_USER} /home/jovyan/work
USER ${NB_USER}
RUN jupyter nbconvert --execute --clear-output ${IPYNB_FILE} 
