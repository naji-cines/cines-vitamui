
FROM maven:3.6.3-jdk-11 as build-services
LABEL name=build-services
COPY . /app
RUN cd /app && mvn clean install -DskipTests
RUN cd ui/ui-pastis && mvn clean install -Pdev

FROM node:12.16.1 as build-front
LABEL name=build-front
COPY --from=build-services /app /app
WORKDIR /app/ui/ui-frontend
RUN npm run build:identity && npm run build:portal && npm run buid:pastis
WORKDIR /app/ui/ui-frontend-common
RUN npm run build:prod

FROM adoptopenjdk/openjdk11 as dependencies

LABEL name=dependencies
COPY --from=build-front /app/pom.xml /app/pom.xml
COPY --from=build-front /app/dev-deployment /app/dev-deployment

COPY --from=build-front /app/api/api-security/security-internal/target /app/api/api-security/security-internal/target
COPY --from=build-front /app/api/api-security/security-internal/src/main/config /app/api/api-security/security-internal/src/main/config
COPY --from=build-front /app/api/api-security/security-internal/pom.xml /app/api/api-security/security-internal/pom.xml

COPY --from=build-front /app/api/api-iam/iam-internal/target /app/api/api-iam/iam-internal/target
COPY --from=build-front /app/api/api-iam/iam-internal/src/main/config /app/api/api-iam/iam-internal/src/main/config
COPY --from=build-front /app/api/api-iam/iam-internal/pom.xml /app/api/api-iam/iam-internal/pom.xml

COPY --from=build-front /app/api/api-iam/iam-external/target /app/api/api-iam/iam-external/target
COPY --from=build-front /app/api/api-iam/iam-external/src/main/config /app/api/api-iam/iam-external/src/main/config
COPY --from=build-front /app/api/api-iam/iam-external/pom.xml /app/api/api-iam/iam-external/pom.xml

COPY --from=build-front /app/cas/cas-server/target /app/cas/cas-server/target
COPY -from=build-front /app/cas/cas-server/src/main/config /app/cas/cas-server/src/main/config
COPY -from=build-front /app/cas/cas-server/pom.xml /app/cas/cas-server/pom.xml
COPY -from=build-front /app/cas/pom.xml /app/cas/pom.xml

COPY -from=build-front /app/ui/ui-portal/target /app/ui/ui-portal/target
COPY -from=build-front /app/ui/ui-portal/src/main/config /app/ui/ui-portal/src/main/config
COPY -from=build-front /app/ui/ui-portal/pom.xml /app/ui/ui-portal/pom.xml


COPY -from=build-front /app/ui/ui-identity/target /app/ui/ui-identity/target
COPY -from=build-front /app/ui/ui-identity/src/main/config /app/ui/ui-identity/src/main/config
COPY -from=build-front /app/ui/ui-identity/pom.xml /app/ui/ui-identity/pom.xml

COPY -from=build-front /app/ui/ui-pastis/target /app/ui/ui-pastis/target
COPY -from=build-front /app/ui/ui-pastis/src/main/config /app/ui/ui-pastis/src/main/config
COPY -from=build-front /app/ui/ui-pastis/pom.xml /app/ui/ui-pastis/pom.xml

COPY -from=build-front /app/api/api-iam/iam-internal-client/target /app/api/api-iam/iam-internal-client/target
COPY -from=build-front /app/api/api-iam/iam-internal-client/pom.xml /app/api/api-iam/iam-internal-client/pom.xml

COPY -from=build-front /app/api/api-iam/iam-external-client/target /app/api/api-iam/iam-external-client/target
COPY -from=build-front /app/api/api-iam/iam-external-client/pom.xml /app/api/api-iam/iam-external-client/pom.xml

COPY -from=build-front /app/api/api-iam/iam-commons/target /app/api/api-iam/iam-commons/target
COPY -from=build-front /app/api/api-iam/iam-commons/pom.xml /app/api/api-iam/iam-commons/pom.xml

COPY -from=build-front /app/commons /app/commons
COPY -from=build-front /app/api/api-iam/iam-commons /app/api/api-iam/iam-commons
COPY -from=build-front /app/api/api-iam/iam-security /app/api/api-iam/iam-security
COPY -from=build-front /app/api/api-security/security-client /app/api/api-security/security-client
COPY -from=build-front /app/api/api-security/security-commons /app/api/api-security/security-commons

COPY -from=build-front /app/ui/ui-frontend/target /app/ui/ui-frontend/target
COPY -from=build-front /app/ui/ui-frontend/dist /app/ui/ui-frontend/dist
COPY -from=build-front /app/ui/ui-frontend/pom.xml /app/ui/ui-frontend/pom.xml

COPY -from=build-front /app/ui/ui-commons/target /app/ui/ui-commons/target
COPY -from=build-front /app/ui/ui-commons/pom.xml /app/ui/ui-commons/pom.xml


COPY -from=build-front /app/ui/ui-frontend-common/dist/ /app/ui/ui-frontend-common/dist

FROM adoptopenjdk/openjdk11 AS security-internal
LABEL name=security-internal
COPY --from=dependencies /app/commons/commons-rest /app/commons/commons-rest
COPY --from=dependencies /app/commons/commons-api /app/commons/commons-api
COPY --from=dependencies /app/api/api-security/security-commons /app/api/api-security/security-commons
COPY --from=dependencies /app/commons/commons-mongo /app/commons/commons-mongo
COPY --from=dependencies /app/api/api-security/security-internal /app/api/api-security/security-internal
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 8084
ENTRYPOINT ["java","-jar","api/api-security/security-internal/target/security-internal-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:api/api-security/security-internal/src/main/config/security-internal-application-dev.yml"]


FROM adoptopenjdk/openjdk11 AS iam-internal
LABEL name=iam-internal
COPY --from=dependencies /app/commons/commons-vitam /app/commons/commons-vitam
COPY --from=dependencies /app/commons/commons-logbook /app/commons/commons-logbook
COPY --from=dependencies /app/commons/commons-mongo /app/commons/commons-mongo
COPY --from=dependencies /app/commons/commons-rest /app/commons/commons-rest
COPY --from=dependencies /app/commons/commons-api /app/commons/commons-api
COPY --from=dependencies /app/api/api-iam/iam-commons /app/api/api-iam/iam-commons
COPY --from=dependencies /app/api/api-iam/iam-security /app/api/api-iam/iam-security
COPY --from=dependencies /app/api/api-security/security-client /app/api/api-security/security-client
COPY --from=dependencies /app/api/api-iam/iam-internal /app/api/api-iam/iam-internal
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 7083
ENTRYPOINT ["java","-Dvitam.config.folder=api/api-iam/iam-internal/src/main/config/dev-vitam","-jar","api/api-iam/iam-internal/target/iam-internal-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:api/api-iam/iam-internal/src/main/config/iam-internal-application-dev.yml"]

FROM adoptopenjdk/openjdk11 AS iam-external
LABEL name=iam-external
COPY --from=dependencies /app/commons/commons-vitam /app/commons/commons-vitam
COPY --from=dependencies /app/commons/commons-rest /app/commons/commons-rest
COPY --from=dependencies /app/commons/commons-api /app/commons/commons-api
COPY --from=dependencies /app/api/api-iam/iam-commons /app/api/api-iam/iam-commons
COPY --from=dependencies /app/api/api-iam/iam-security /app/api/api-iam/iam-security
COPY --from=dependencies /app/api/api-security/security-client /app/api/api-security/security-client
COPY --from=dependencies /app/api/api-iam/iam-internal-client /app/api/api-iam/iam-internal-client
COPY --from=dependencies /app/api/api-iam/iam-external /app/api/api-iam/iam-external
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 8083
ENTRYPOINT ["java","-jar","api/api-iam/iam-external/target/iam-external-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:api/api-iam/iam-external/src/main/config/iam-external-application-dev.yml"]

FROM adoptopenjdk/openjdk11 AS ui-portal
LABEL name=ui-portal
COPY --from=dependencies /app/api/api-iam/iam-external-client /app/api/api-iam/iam-external-client
COPY --from=dependencies /app/ui/ui-frontend /app/ui/ui-frontend
COPY --from=dependencies /app/ui/ui-commons /app/ui/ui-commons
COPY --from=dependencies /app/commons/commons-rest /app/commons/commons-rest
COPY --from=dependencies /app/commons/commons-api /app/commons/commons-api
COPY --from=dependencies /app/api/api-iam/iam-commons /app/api/api-iam/iam-commons
COPY --from=dependencies /app/ui/ui-portal /app/ui/ui-portal
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 9000
ENTRYPOINT ["java","-jar","ui/ui-portal/target/ui-portal-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:ui/ui-portal/src/main/config/ui-portal-application-dev.yml"]


FROM adoptopenjdk/openjdk11 AS ui-identity
LABEL name=ui-identity
COPY --from=dependencies /app/api/api-iam/iam-external-client /app/api/api-iam/iam-external-client
COPY --from=dependencies /app/ui/ui-frontend /app/ui/ui-frontend
COPY --from=dependencies /app/ui/ui-commons /app/ui/ui-commons
COPY --from=dependencies /app/commons/commons-rest /app/commons/commons-rest
COPY --from=dependencies /app/commons/commons-api /app/commons/commons-api
COPY --from=dependencies /app/commons/commons-security /app/commons/commons-security
COPY --from=dependencies /app/api/api-iam/iam-commons /app/api/api-iam/iam-commons
COPY --from=dependencies /app/ui/ui-identity /app/ui/ui-identity
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 9001
ENTRYPOINT ["java","-jar","ui/ui-identity/target/ui-identity-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:ui/ui-identity/src/main/config/ui-identity-application-dev.yml"]


FROM adoptopenjdk/openjdk11 AS ui-pastis
LABEL name=ui-pastis
COPY --from=dependencies /app/ui/ui-pastis /app/ui/ui-pastis
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 8051
ENTRYPOINT ["java","-jar","ui/ui-pastis/target/ui-pastis-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:ui/ui-pastis/src/main/config/ui-pastis-application-dev.yml"]

FROM adoptopenjdk/openjdk11 AS cas-server
LABEL name=cas-server
COPY --from=dependencies /app/commons/commons-api /app/commons/commons-api
COPY --from=dependencies /app/api/api-iam/iam-commons /app/api/api-iam/iam-commons
COPY --from=dependencies /app/api/api-iam/iam-external-client /app/api/api-iam/iam-external-client
COPY --from=dependencies /app/cas /app/cas
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java","-Dspring.config.additional-location=cas/cas-server/src/main/config/cas-server-application-dev.yml","-jar","-Xms128m","-Xmx512m","cas/cas-server/target/cas-server.war"]

FROM nginx:alpine AS PORTAL
LABEL name=portal-front
COPY --from=dependencies /app/ui/ui-frontend-common/dist /usr/share/nginx/html
COPY --from=dependencies /app/ui/ui-frontend/dist/portal/ /usr/share/nginx/html
COPY --from=dependencies /app/ui/ui-frontend/dist/sass/ /usr/share/nginx/html

FROM nginx:alpine AS IDENTITY
LABEL name=identity-front
COPY --from=dependencies /app/ui/ui-frontend-common/dist /usr/share/nginx/html
COPY --from=dependencies /app/ui/ui-frontend/dist/identity/ /usr/share/nginx/html
COPY --from=dependencies /app/ui/ui-frontend/dist/sass/ /usr/share/nginx/html

FROM nginx:alpine AS PASTIS
LABEL name=pastis-front
COPY --from=dependencies /app/ui/ui-frontend-common/dist /usr/share/nginx/html
COPY --from=dependencies /app/ui/ui-frontend/dist/pastis/ /usr/share/nginx/html
COPY --from=dependencies /app/ui/ui-frontend/dist/sass/ /usr/share/nginx/html
