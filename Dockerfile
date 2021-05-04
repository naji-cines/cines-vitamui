FROM adoptopenjdk/openjdk11 as dependencies
COPY pom.xml /app/pom.xml
COPY dev-deployment /app/dev-deployment

COPY api/api-security/security-internal/target /app/api/api-security/security-internal/target
COPY api/api-security/security-internal/src/main/config /app/api/api-security/security-internal/src/main/config
COPY api/api-security/security-internal/pom.xml /app/api/api-security/security-internal/pom.xml

COPY api/api-iam/iam-internal/target /app/api/api-iam/iam-internal/target
COPY api/api-iam/iam-internal/src/main/config /app/api/api-iam/iam-internal/src/main/config
COPY api/api-iam/iam-internal/pom.xml /app/api/api-iam/iam-internal/pom.xml

COPY api/api-iam/iam-external/target /app/api/api-iam/iam-external/target
COPY api/api-iam/iam-external/src/main/config /app/api/api-iam/iam-external/src/main/config
COPY api/api-iam/iam-external/pom.xml /app/api/api-iam/iam-external/pom.xml

COPY cas/cas-server/target /app/cas/cas-server/target
COPY cas/cas-server/src/main/config /app/cas/cas-server/src/main/config
COPY cas/cas-server/pom.xml /app/cas/cas-server/pom.xml
COPY cas/pom.xml /app/cas/pom.xml

COPY ui/ui-portal/target /app/ui/ui-portal/target
COPY ui/ui-portal/src/main/config /app/ui/ui-portal/src/main/config
COPY ui/ui-portal/pom.xml /app/ui/ui-portal/pom.xml


COPY ui/ui-identity/target /app/ui/ui-identity/target
COPY ui/ui-identity/src/main/config /app/ui/ui-identity/src/main/config
COPY ui/ui-identity/pom.xml /app/ui/ui-identity/pom.xml

COPY ui/ui-pastis/target /app/ui/ui-pastis/target
COPY ui/ui-pastis/src/main/config /app/ui/ui-pastis/src/main/config
COPY ui/ui-pastis/pom.xml /app/ui/ui-pastis/pom.xml

#RUN cd /app && mvn clean install -DskipTests

COPY api/api-iam/iam-internal-client/target /app/api/api-iam/iam-internal-client/target
COPY api/api-iam/iam-internal-client/pom.xml /app/api/api-iam/iam-internal-client/pom.xml

COPY api/api-iam/iam-external-client/target /app/api/api-iam/iam-external-client/target
COPY api/api-iam/iam-external-client/pom.xml /app/api/api-iam/iam-external-client/pom.xml

COPY commons /app/commons
COPY api/api-iam/iam-commons /app/api/api-iam/iam-commons
COPY api/api-iam/iam-security /app/api/api-iam/iam-security
COPY api/api-security/security-client /app/api/api-security/security-client
COPY api/api-security/security-commons /app/api/api-security/security-commons

COPY ui/ui-frontend/target /app/ui/ui-frontend/target
COPY ui/ui-frontend/dist /app/ui/ui-frontend/dist
COPY ui/ui-frontend/pom.xml /app/ui/ui-frontend/pom.xml

COPY ui/ui-commons/target /app/ui/ui-commons/target
COPY ui/ui-commons/pom.xml /app/ui/ui-commons/pom.xml

FROM cines/vitamui-security-internal AS security-internal
COPY --from=dependencies /app/commons/commons-rest /app/commons/commons-rest
COPY --from=dependencies /app/commons/commons-api /app/commons/commons-api
COPY --from=dependencies /app/api/api-security/security-commons /app/api/api-security/security-commons
COPY --from=dependencies /app/commons/commons-mongo /app/commons/commons-mongo
COPY --from=dependencies /app/api/api-security/security-internal /app/api/api-security/security-internal
WORKDIR /app
EXPOSE 8084
ENTRYPOINT ["java","-jar","api/api-security/security-internal/target/security-internal-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:api/api-security/security-internal/src/main/config/security-internal-application-dev.yml"]


FROM cines/vitamui-iam-internal AS iam-internal
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
ENTRYPOINT ["java","-jar","api/api-iam/iam-internal/target/iam-internal-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:api/api-iam/iam-internal/src/main/config/iam-internal-application-dev.yml"]

FROM cines/vitamui-iam-external AS iam-external
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

FROM cines/vitamui-ui-portal AS ui-portal
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


FROM cines/vitamui-ui-identity AS ui-identity
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


FROM cines/vitamui-ui-pastis AS ui-pastis
COPY --from=dependencies /app/ui/ui-pastis /app/ui/ui-pastis
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 8051
ENTRYPOINT ["java","-jar","ui/ui-pastis/target/ui-pastis-4.4.0-SNAPSHOT.jar","-Xms128m","-Xmx512m","--spring.config.additional-location=file:ui/ui-pastis/src/main/config/ui-pastis-application-dev.yml"]

FROM cines/vitamui-cas-server AS cas-server
COPY --from=dependencies /app/api/api-iam/iam-external-client /app/api/api-iam/iam-external-client
COPY --from=dependencies /app/cas /app/cas
COPY --from=dependencies /app/dev-deployment /app/dev-deployment
WORKDIR /app
EXPOSE 8080
ENTRYPOINT ["java","-jar","cas/cas-server/target/cas-server.war","-Xms128m","-Xmx512m","--spring.config.additional-location=file:cas/cas-server/src/main/config/cas-server-application-dev.yml"]
