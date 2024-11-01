#!/usr/bin/env bash
podman build -t localhost/abcoden/sopros_osa_frontend:latest .
podman tag localhost/abcoden/sopros_osa_frontend docker.io/abcoden/sopros_osa_frontend
podman push docker.io/abcoden/sopros_osa_frontend