ARG DOCKER_IMAGE
FROM $DOCKER_IMAGE

# root user is required for the coming operations
USER root

# create servers
COPY ./servers.json /tmp/servers.json
WORKDIR /tmp/

ARG APP_PREFIX
RUN sed -i -r "s/%%APP_PREFIX%%/${APP_PREFIX}/g" servers.json
ARG POSTGRES_HOST_NAME
RUN sed -i -r "s/%%POSTGRES_HOST_NAME%%/${POSTGRES_HOST_NAME}/g" servers.json
ARG POSTGRES_PORT
RUN sed -i -r "s/%%POSTGRES_PORT%%/${POSTGRES_PORT}/g" servers.json
ARG POSTGRES_DEFAULT_DATABASE_NAME
RUN sed -i -r "s/%%POSTGRES_DEFAULT_DATABASE_NAME%%/${POSTGRES_DEFAULT_DATABASE_NAME}/g" servers.json
ARG POSTGRES_SUPER_USER_ROLE_NAME
RUN sed -i -r "s/%%POSTGRES_SUPER_USER_ROLE_NAME%%/${POSTGRES_SUPER_USER_ROLE_NAME}/g" servers.json

# import servers
RUN python /pgadmin4/setup.py --load-servers /tmp/servers.json

# create passwords
WORKDIR /var/lib/pgadmin/storage/
ARG PGADMIN_USER_DIR
RUN mkdir -m 700 ./${PGADMIN_USER_DIR} && \
  echo "${POSTGRES_HOST_NAME}:${POSTGRES_HOST_NAME}:${POSTGRES_DEFAULT_DATABASE_NAME}:${POSTGRES_SUPER_USER_ROLE_NAME}:${POSTGRES_SUPER_USER_SECRET}" > ./${PGADMIN_USER_DIR}/pgpassfile && \ 
  chmod 600 ./${PGADMIN_USER_DIR}/pgpassfile
