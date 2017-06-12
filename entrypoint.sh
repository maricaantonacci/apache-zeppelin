#!/bin/bash

# Zeppelin config
if [ ! -z "$MASTER" ]; then
  echo "export MASTER=${MASTER}" >> /zeppelin/conf/zeppelin-env.sh
fi
  
if [ ! -z "$SPARK_HOME" ]; then
  echo "export SPARK_HOME=${SPARK_HOME}" >> /zeppelin/conf/zeppelin-env.sh
fi

if [ ! -z "$HADOOP_CONF_DIR" ]; then
  echo "export HADOOP_CONF_DIR=${HADOOP_CONF_DIR}" >> /zeppelin/conf/zeppelin-env.sh 
fi

if [ ! -z "$SPARK_SUBMIT_OPTIONS" ]; then
  echo "export SPARK_SUBMIT_OPTIONS=${SPARK_SUBMIT_OPTIONS}" >> /zeppelin/conf/zeppelin-env.sh
fi

cd ${SPARK_HOME}
j2 core-site.xml.j2 > ${SPARK_HOME}/conf/core-site.xml
cd -

if [ ! -z "$ADMIN_PASSWORD" ]; then
  sed '/zeppelin.anonymous.allowed/!b;n;c<value>false<\/value>' /zeppelin/conf/zeppelin-site.xml.template > /zeppelin/conf/zeppelin-site.xml 
  cp /zeppelin/conf/shiro.ini.template /zeppelin/conf/shiro.ini
  sed -i '/user[1-3] =.*/d' /zeppelin/conf/shiro.ini
  sed -i 's/password1/'"$ADMIN_PASSWORD"'/' /zeppelin/conf/shiro.ini
fi


for k in `set | grep ^ZEPPELIN_ | cut -d= -f1`; do
    eval v=\$$k
    echo "export $k=$v" >> /zeppelin/conf/zeppelin-env.sh
done

exec "$@"



