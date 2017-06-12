FROM marica/spark-mesos

# reset properties inherited from parent image
ENTRYPOINT []
CMD []
WORKDIR /

RUN wget http://archive.apache.org/dist/zeppelin/zeppelin-0.7.1/zeppelin-0.7.1-bin-all.tgz && \
    mkdir /zeppelin && \
    tar xfz zeppelin-0.7.1-bin-all.tgz -C zeppelin --strip-components 1 && \
    rm zeppelin-0.7.1-bin-all.tgz

ENV MASTER="" \
    SPARK_HOME="/spark" \
    SPARK_SUBMIT_OPTIONS="" 

COPY entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh

WORKDIR /zeppelin

ENTRYPOINT ["/entrypoint.sh"]
CMD       [ "/zeppelin/bin/zeppelin.sh", "start" ]
