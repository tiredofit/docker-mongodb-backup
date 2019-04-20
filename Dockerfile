FROM tiredofit/mongo-builder:latest as mongo-packages

FROM tiredofit/alpine:edge
LABEL maintainer="Dave Conroy (dave at tiredofit dot ca)"

### Copy Mongo Packages
COPY --from=mongo-packages / /usr/src/apk

### Set Environment Variables
   ENV ENABLE_SMTP=FALSE

### Dependencies
   RUN set -x && \
       apk update && \
       apk add \
    	   bzip2 \
    	   xz && \
       \        
       ## Locally Install Mongo Package
       cd /usr/src/apk && \
       apk add -t .db-backup-mongo-deps --allow-untrusted \
           mongodb-tools*.apk \
           && \
       \
       rm -rf /var/cache/apk/* && \
       rm -rf /usr/src/* 

### S6 Setup
   ADD install/s6 /etc/s6
