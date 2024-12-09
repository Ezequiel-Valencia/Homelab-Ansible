### Network Stack

Each container has it's own loopback interface, associated with 127.0.0.1. This is different from the host loopback interface.

Because all of the containers use the gluetuen network stack, this means they all have the same IP address and local interface. So when communicating between different services which use glueten as the network stack, all that needs to be done is set the port and IP address to localhost.

Failed attempts:
    - Docker links 
        - Would have a cyclic dependency with containers that use the VPN
    - Each container has its own individual network
        - Not possible when wanting to use another services network stack as the gateway for communication with other conatiners
    - Manually set the IP table routes
        - To much of a pain
    - Set the VPN container as the gateway
        - To much of a pain


### Health Check

Health check currently has intervals of 4 minutes not to spam the website which allows checking region. Start period does not seem necessary, and may not be helpful.

[Source](https://www.paulsblog.dev/how-to-successfully-implement-a-healthcheck-in-docker-compose/)


### Old Env Variables
```
media_path_tv: "{{ mounted_path }}/media/tv"
media_path_movies: "{{ mounted_path }}/media/movies"
media_path_books: "{{ mounted_path }}/media/books"
media_path_music: "{{ mounted_path }}/media/music"
media_path_downloads: "{{ mounted_path }}/media/downloads"

jellyfin_config_path: "{{ defualt_relative_docker_data_path }}/config/jellyfin"
qbit_config_path: "{{ defualt_relative_docker_data_path }}/config/qbittorent"
jackett_config_path: "{{ defualt_relative_docker_data_path }}/config/jackett"
bazarr_config_path: "{{ defualt_relative_docker_data_path }}/config/bazarr"
radarr_config_path: "{{ defualt_relative_docker_data_path }}/config/radarr"
sonarr_config_path: "{{ defualt_relative_docker_data_path }}/config/sonarr"
gluetun_config_path: "{{ defualt_relative_docker_data_path }}/config/gluetun"
lidarr_config_path: "{{ defualt_relative_docker_data_path }}/lidarr/config"
readarr_config_path: "{{ defualt_relative_docker_data_path }}/readarr/config"

# Needed since applications communicate giving paths within their own systems since
# they believe they are communicating in the same machine
internal_downloads: "/media/downloads"
internal_movies: "/media/movies"
internal_tv: "/media/tv"
internal_books: "/media/books"
internal_music: "/music"

container_name: gluetun

unified_network: "service:{{ container_name }}"

# Either it matches exactly the VPN region or exits with status 1
health_check_vpn:
  test: 'curl -s --fail https://ipinfo.io/region | grep -qxo "{{ vpn_region }}" || exit 1'
  interval: 240s
  retries: 2
  start_period: 30s
  timeout: 10s

```


### Old Compose File

Before switching to K8 this was the compose file to start everything.

```
version: "3.3"
services:
    gluetun:
        image: qmcgaw/gluetun:latest
        restart: unless-stopped
        container_name: "{{ container_name }}"
        hostname: gluetun
        networks:
            gluetun_vpn:
        cap_add:
            - NET_ADMIN
        environment:
            - VPN_SERVICE_PROVIDER={{ vpn_service_provider }}
            - VPN_TYPE=wireguard
            - WIREGUARD_PRIVATE_KEY={{ wireguard_private_key }}
            - WIREGUARD_ADDRESSES={{ wireguard_address }}
            - SERVER_CITIES=New York NY
            - DOT_PROVIDERS=quad9
            - UPDATER_PERIOD=48h
        ports:
            - "7676:6767" # Bazarr
            - "9898:8989" # Sonar
            - "8787:7878" # Raddarr
            # - "7878:8787" # Readarr
            - "9845:9117" # Jackett
            - "8687:8686" # Lidarr
            # Qbittorent
            - "9078:9078"
            - "7439:6881/tcp"
            - "7439:6881/udp"
        volumes:
            - "{{ gluetun_config_path }}:/gluetun:Z"
        healthcheck:
            test: {{ health_check_vpn.test }}
            interval: {{ health_check_vpn.interval }}
            retries: {{ health_check_vpn.retries }}
            start_period: {{ health_check_vpn.start_period }}
            timeout: {{ health_check_vpn.timeout }}

    # Request shows automatically, https://hub.docker.com/r/linuxserver/sonarr
    sonarr:
        image: lscr.io/linuxserver/sonarr:latest
        restart: unless-stopped
        network_mode: "{{ unified_network }}"
        container_name: sonarr
        depends_on:
            - gluetun
        environment:
            - TZ={{ time_zone }}
            - PUID={{ users[0].PUID }}
            - PGID={{ group_return_values.gid }}
        volumes:
            - "{{ sonarr_config_path }}:/config:Z"
            - "{{ media_path_tv }}:{{ internal_tv }}"
            - "{{ media_path_downloads }}:{{ internal_downloads }}"
        healthcheck:
            test: {{ health_check_vpn.test }}
            interval: {{ health_check_vpn.interval }}
            retries: {{ health_check_vpn.retries }}
            start_period: {{ health_check_vpn.start_period }}
            timeout: {{ health_check_vpn.timeout }}

    # Request movies automatically, https://hub.docker.com/r/linuxserver/radarr
    radarr:
        image: lscr.io/linuxserver/radarr:latest
        restart: unless-stopped
        network_mode: "{{ unified_network }}"
        container_name: radarr
        depends_on:
            - gluetun
        environment:
            - TZ={{ time_zone }}
            - PUID={{ users[0].PUID }}
            - PGID={{ group_return_values.gid }}
        volumes:
            - "{{ radarr_config_path }}:/config:Z"
            - "{{ media_path_movies }}:{{ internal_movies }}"
            - "{{ media_path_downloads }}:{{ internal_downloads }}"
        healthcheck:
            test: {{ health_check_vpn.test }}
            interval: {{ health_check_vpn.interval }}
            retries: {{ health_check_vpn.retries }}
            start_period: {{ health_check_vpn.start_period }}
            timeout: {{ health_check_vpn.timeout }}
    
    bazarr:
        image: lscr.io/linuxserver/bazarr:latest
        restart: unless-stopped
        container_name: bazarr
        depends_on:
            - gluetun
        environment:
            - TZ={{ time_zone }}
            - PUID={{ users[0].PUID }}
            - PGID={{ group_return_values.gid }}
        network_mode: "{{ unified_network }}"
        volumes:
            - "{{ bazarr_config_path }}:/config:Z"
            - "{{ media_path_tv }}:{{ internal_tv }}"
            - "{{ media_path_movies }}:{{ internal_movies }}"
        healthcheck:
            test: {{ health_check_vpn.test }}
            interval: {{ health_check_vpn.interval }}
            retries: {{ health_check_vpn.retries }}
            start_period: {{ health_check_vpn.start_period }}
            timeout: {{ health_check_vpn.timeout }}
    
    lidarr:
        image: lscr.io/linuxserver/lidarr:latest
        restart: unless-stopped
        container_name: lidarr
        depends_on:
            - gluetun
        environment:
            - TZ={{ time_zone }}
            - PUID={{ users[0].PUID }}
            - PGID={{ group_return_values.gid }}
        network_mode: "{{ unified_network }}"
        volumes:
            - "{{ lidarr_config_path }}:/config:Z"
            - "{{ media_path_music }}:{{ internal_music }}"
            - "{{ media_path_downloads }}:{{ internal_downloads }}"
        healthcheck:
            test: {{ health_check_vpn.test }}
            interval: {{ health_check_vpn.interval }}
            retries: {{ health_check_vpn.retries }}
            start_period: {{ health_check_vpn.start_period }}
            timeout: {{ health_check_vpn.timeout }}

    # readarr:
    #     image: lscr.io/linuxserver/readarr:develop
    #     restart: unless-stopped
    #     container_name: readarr
    #     depends_on:
    #         - gluetun
    #     environment:
    #         - TZ={{ time_zone }}
    #         - PUID="{{ users[0].PUID }}"
    #         - PGID={{ group_return_values.gid }}
    #         - UMASK={{ media_UMASK }}
    #     network_mode: "{{ unified_network }}"
    #     volumes:
    #         - "{{ readarr_config_path }}:/config:Z"
    #         - "{{ media_path_books }}:{{ internal_books }}"
    #         - "{{ media_path_downloads }}:{{ internal_downloads }}"
    #     healthcheck:
    #         test: {{ health_check_vpn.test }}
    #         interval: {{ health_check_vpn.interval }}
    #         retries: {{ health_check_vpn.retries }}
    #         start_period: {{ health_check_vpn.start_period }}
    #         timeout: {{ health_check_vpn.timeout }}
    
    # Create Jackett, helps parse stuff of interest
    jackett:
        image: lscr.io/linuxserver/jackett:latest
        restart: unless-stopped
        container_name: jackett
        depends_on:
            - gluetun
        environment:
            - TZ={{ time_zone }}
            - PUID={{ users[0].PUID }}
            - PGID={{ group_return_values.gid }}
            - AUTO_UPDATE=true
        network_mode: "{{ unified_network }}"
        volumes:
            - "{{ jackett_config_path }}:/config:Z"
        healthcheck:
            test: {{ health_check_vpn.test }}
            interval: {{ health_check_vpn.interval }}
            retries: {{ health_check_vpn.retries }}
            start_period: {{ health_check_vpn.start_period }}
            timeout: {{ health_check_vpn.timeout }}
    
    # Actually does the downloading, https://hub.docker.com/r/linuxserver/qbittorrent
    qbittorrent:
        image: lscr.io/linuxserver/qbittorrent:latest
        restart: unless-stopped
        container_name: qbittorrent
        depends_on:
            - gluetun
        environment:
            - TZ={{ time_zone }}
            - WEBUI_PORT=9078
            - PUID={{ users[1].PUID }}
            - PGID={{ group_return_values.gid }}
        network_mode: "{{ unified_network }}"
        volumes:
            - "{{ qbit_config_path }}:/config:Z"
            - "{{ media_path_downloads }}:{{ internal_downloads }}"
        healthcheck:
            test: {{ health_check_vpn.test }}
            interval: {{ health_check_vpn.interval }}
            retries: {{ health_check_vpn.retries }}
            start_period: {{ health_check_vpn.start_period }}
            timeout: {{ health_check_vpn.timeout }}
        
    jellyfin:
        image: lscr.io/linuxserver/jellyfin:latest
        restart: unless-stopped
        container_name: jellyfin
        environment:
            - TZ={{ time_zone }}
            - PUID={{ users[2].PUID }}
            - PGID={{ group_return_values.gid }}
        ports:
            - "7260:8096"
        volumes:
            - "{{ jellyfin_config_path }}:/config:Z" # Z flag makes it only available to this container
            - "{{ media_path_tv }}:{{ internal_tv }}"
            - "{{ media_path_movies }}:{{ internal_movies }}"



networks:
    gluetun_vpn:

```

