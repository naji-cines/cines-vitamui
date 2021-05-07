(docker stop security-internal && docker rm security-internal) || echo 'pas de container à stopper'
(docker stop iam-internal && docker rm iam-internal) || echo 'pas de container à stopper'
(docker stop iam-external && docker rm iam-external) || echo 'pas de container à stopper'
(docker stop cas-server && docker rm cas-server) || echo 'pas de container à stopper'
(docker stop ui-identity && docker rm ui-identity) || echo 'pas de container à stopper'
(docker stop ui-portal && docker rm ui-portal) || echo 'pas de container à stopper'
(docker stop ui-pastis && docker rm ui-pastis) || echo 'pas de container à stopper'
(docker stop front-pastis && docker rm front-pastis) || echo 'pas de container à stopper'
(docker stop front-portal && docker rm front-portal) || echo 'pas de container à stopper'
(docker stop front-identity && docker rm front-identity) || echo 'pas de container à stopper'

docker run -d --network vitamui --name security-internal -p "8084:8084" cines/vitamui-security-internal
docker run -d --network vitamui --name iam-internal -p "7083:7083" cines/vitamui-iam-internal
docker run -d --network vitamui --name iam-external -p "8083:8083" cines/vitamui-iam-external
docker run -d --network vitamui --name cas-server -p "8080:8080" cines/vitamui-cas
docker run -d --network vitamui --name ui-portal -p "9000:9000" cines/vitamui-ui-portal
docker run -d --network vitamui --name ui-identity -p "9001:9001" cines/vitamui-ui-identity
docker run -d --network vitamui --name ui-pastis -p "8051:8051" cines/vitamui-ui-pastis
docker run -d --network vitamui --name front-pastis -p "4251:80" cines/vitamui-front-pastis
docker run -d --network vitamui --name front-identity -p "4201:80" cines/vitamui-front-identity
docker run -d --network vitamui --name front-portal -p "4200:80" cines/vitamui-front-portal
