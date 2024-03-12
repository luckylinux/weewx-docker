# Introduction
An alternative Project compared to what is offered at https://github.com/felddy/weewx-docker/.

Unfortunately I couldn't get felddy's weewx-docker Image to work in my Environment.
The Container would continue to reboot non-stop and only a single line about Busybox or something like that could be found in the logs.

And looking at the code, it's not very clear why.

# Environment
In my case this is used to interface to a Sainlogic WS3500 Weather Station.

I am using:
- Hardware: Raspberry Pi 2
- Distribution: Raspberry Pi OS 32bit armv7l - Debian Bookworm (12)
- Container Platform: Podman 4.9.3 Rootless (from APT pinning from Debian Trixie/Testing)
- Weather Station: Sainlogic WS3500

To install Podman 4.9.3 on Debian Stable, refer to https://github.com/luckylinux/podman-tools/blob/main/upgrade_ubuntu_podman_to_testing.sh.
Note: in the case of Raspberry Pi OS, you also need to install debian-archive-keyring:
- Download (from the Debian Testing Repository): https://packages.debian.org/trixie/all/debian-archive-keyring/download
- Install: `dpkg -i debian-archive-keyring_*.deb`

# Build
I decided to split the Dockerfile into 2 parts:
- System Setup (install system tools/packages)
- Application Setup (setup application environment)

The Reason for this is that it is VERY slow on a Raspberry Pi2 to install the System Packages (think Bash, Curl, Wget, ...), and I'm not very likely to modify those.

On the other hand, the Application Setup will most likely be touched several times.

There are probably better ways, but I am not very familiar with those.

Feel free to suggest :).

This will build 2 sets of Images, based on:
- Alpine
- Debian

Feel free to comment the base you don't want in the `build_bases.sh` and `build_weewx.sh` files.

## Base Image
The first Step is to build the "base" image.

Run
```
./build_bases.sh
```

This will build:
- weewx-base:alpine-latest
- weewx-base:debian-latest

## WeeWX Image
The second Step is to build the "weewx" image.

Run
```
./build_weewx.sh
```

This will build:
- weewx:alpine-latest
- weewx:debian-latest

# Compose
The Docker / Podman compose file should be as simple as
```
version: "3.8"

services:
  weewx:
    image: localhost/weewx:debian-latest
    container_name: weewx
    restart: "unless-stopped"
    networks:
      - podman
    volumes:
      - ~/containers/config/weewx:/etc/weewx
      - ~/containers/data/weewx:/data
    env_file:
      - .env
    environment:
      - TIMEZONE=UTC
#    devices:
#      - "/dev/ttyUSB0:/dev/ttyUSB0"

networks:
  podman:
    external: true
```

# Run
Run
```
podman-compose up -d
```

# Manual Intervention
By default, the application starts an infinite loop after the required commands are executed by `docker-entrypoint.sh`.

In this way it's always possible to enter the Container to issue "manual commands":
```
podman exec -it weewx /bin/bash
```
