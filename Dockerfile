# Dockerfile for Metabase on Google App Engine
#   https://github.com/metabase/metabase/issues/3983
# 

FROM gcr.io/google-appengine/openjdk:8

# Set locale to UTF-8
ARG MB_DB_PORT=5432
ARG METABASE_SQL_INSTANCE=inspection-fund:us-east1:stoa-postgress-inspection=tcp:5432
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV MB_JETTY_PORT=8080
ENV MB_DB_TYPE=postgres
ENV MB_DB_PORT=5432
ENV MB_DB_USER=metabase
ENV MB_DB_PASS=C2m4V9Md97M739Tvm46
ENV MB_DB_DBNAME=metabase
ENV METABASE_SQL_INSTANCE=inspection-fund:us-east1:stoa-postgress-inspection=tcp:5432


# Set Java options
#   1. Enable the detection of container-limited amount of RAM
#     https://hub.docker.com/_/openjdk/
#   2. Set UTF-8
ENV JAVA_OPTS "-XX:+IgnoreUnrecognizedVMOptions -XX:+UseCGroupMemoryLimitForHeap -Dfile.encoding=UTF-8 --add-opens=java.base/java.net=ALL-UNNAMED --add-modules=java.xml.bind"

# Add Metabase jar
ADD http://downloads.metabase.com/v0.34.3/metabase.jar ./metabase.jar

# Google Cloud SQL support
ADD https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64 ./cloud_sql_proxy
RUN chmod +x ./cloud_sql_proxy

# Expose our default runtime port
EXPOSE 8080

# run it
CMD ./cloud_sql_proxy -instances=${METABASE_SQL_INSTANCE} & (java -jar ./metabase.jar migrate release-locks && java -jar ./metabase.jar)
