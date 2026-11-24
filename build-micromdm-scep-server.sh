#!/bin/sh

docker buildx build --platform linux/amd64 --attest type=provenance,mode=max --sbom=true -t pdbs/micromdm-scep-server --push .

