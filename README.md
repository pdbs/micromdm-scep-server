# micromdm-scep-server
### docker-compose service with Traefik frontend ###
```
version: '3'

services:
  scep:
    image: pdbs/micromdm-scep-server
    hostname: ${HOSTNAME}
    volumes:
        - /${PATH_TO_CA_DIR}/CA:/depot
        - /etc/localtime:/etc/localtime:ro
    environment:
      TZ: "Europe/Zurich"
      CAPASS: "${CA_PASSOWRD}"
      CHALLENGE: "${SCEP_CHALLENGE}"
    networks:
        - swarm-traefik
    deploy:
      labels:
        - "traefik.enable=true"
        - "traefik.docker.network=swarm-traefik"
        - "traefik.http.services.micromdm-scep-server.loadbalancer.server.port=8080"
        - "traefik.http.routers.micromdm-scep-server.rule=Host(`${HOSTNAME}`)"
        - "traefik.http.routers.micromdm-scep-server.entrypoints=http"
        - "traefik.http.routers.micromdm-scep-server.middlewares=https_redirect"
        - "traefik.http.routers.micromdm-scep-server-https.rule=Host(`${HOSTNAME}`)"
        - "traefik.http.routers.micromdm-scep-server-https.entrypoints=https"
        - "traefik.http.routers.micromdm-scep-server-https.tls=true"
        - "traefik.http.routers.micromdm-scep-server-https.tls.options=default"
        - "traefik.http.routers.micromdm-scep-server-https.tls.certresolver=default"
        - "traefik.http.middlewares.https_redirect.redirectscheme.scheme=https"
        - "traefik.http.middlewares.https_redirect.redirectscheme.permanent=true"

networks:
    swarm-traefik:
        external: true
```
### Configuration Variables

$HOSTNAME: FQDN of scep server

$PATH_TO_CA_DIR: directory for CA

$CA_PASSOWRD: CA private key password

$SCEP_CHALLENGE: SCEP challenge password

To create your own CA, start container using --entrypoint /bin/bash and invoke
```
./scepserver-linux-amd64 ca -init 
```
To specify your own CA attributes:
```
$ ./scepserver-linux-amd64 ca -help
Usage of ca:
  -country string
    	country for CA cert (default "US")
  -depot string
    	path to ca folder (default "depot")
  -init
    	create a new CA
  -key-password string
    	password to store rsa key
  -keySize int
    	rsa key size (default 4096)
  -common_name string
        common name (CN) for CA cert (default "MICROMDM SCEP CA")
  -organization string
    	organization for CA cert (default "scep-ca")
  -organizational_unit string
    	organizational unit (OU) for CA cert (default "SCEP CA")
  -years int
    	default CA years (default 10)
```


