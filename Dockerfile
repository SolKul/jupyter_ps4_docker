FROM jupyter/minimal-notebook
ADD quantum.yml /home/jovyan/quantum.yml
ADD psi4-master.zip /home/jovyan/psi4-master.zip
RUN conda env create -f /home/jovyan/quantum.yml
SHELL ["conda", "run", "-n", "quantum", "/bin/bash", "-c"]
RUN python -m ipykernel install --user --name=quantum
USER root
RUN unzip /home/jovyan/psi4-master.zip -d /home/jovyan/ && \
    mkdir /home/jovyan/psi4-master/build && \
    cd /home/jovyan/psi4-master/build && \
    apt-get update && \
    apt-get install -y build-essential cmake\
    libopenblas-dev libmpfr-dev libeigen3-dev && \
    cmake .. && \
    make -j8 && \
    make install && \
    echo "/usr/local/psi4/lib" >> /opt/conda/envs/quantum/lib/python3.7/site-packages/psi4.pth && \
    cd /home/jovyan/ && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/ && \
    rm -rf /home/jovyan/psi4-master && \
    rm /home/jovyan/psi4-master.zip
SHELL ["/bin/bash", "-c"] 
USER jovyan
