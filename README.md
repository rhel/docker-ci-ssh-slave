```
version: '3.7'

networks:
  ci-ssh-slave:
    name: ci-ssh-slave
    driver: bridge

services:
  ci-ssh-slave:
    container_name: ci-ssh-slave
    image: pearbox/ci-ssh-slave
    environment:
      - CI_SLAVE_SSH_PUBKEY=<put your ssh-rsa here>
    restart: unless-stopped
    ports:
      - "22022:22"
    volumes:
      - /home/ci:/home/ci
      - /var/run/docker.sock:/var/run/docker.sock
    networks:
      - ci-ssh-slave
```
