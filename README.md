[![linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)](https://linuxserver.io)

The [LinuxServer.io](https://linuxserver.io) team brings you another container release featuring :-

 * regular and timely application updates
 * easy user mappings (PGID, PUID)
 * custom base image with s6 overlay
 * weekly base OS updates with common layers across the entire LinuxServer.io ecosystem to minimise space usage, down time and bandwidth
 * regular security updates

Find us at:
* [Discord](https://discord.gg/YWrKVTn) - realtime support / chat with the community and the team.
* [IRC](https://irc.linuxserver.io) - on freenode at `#linuxserver.io`. Our primary support channel is Discord.
* [Blog](https://blog.linuxserver.io) - all the things you can do with our containers including How-To guides, opinions and much more!
* [Podcast](https://anchor.fm/linuxserverio) - on hiatus. Coming back soon (late 2018).

# PSA: Changes are happening

From August 2018 onwards, Linuxserver are in the midst of switching to a new CI platform which will enable us to build and release multiple architectures under a single repo. To this end, existing images for `arm64` and `armhf` builds are being deprecated. They are replaced by a manifest file in each container which automatically pulls the correct image for your architecture. You'll also be able to pull based on a specific architecture tag.

TLDR: Multi-arch support is changing from multiple repos to one repo per container image.

# [linuxserver/minisatip](https://github.com/linuxserver/docker-minisatip)
[![](https://img.shields.io/discord/354974912613449730.svg?logo=discord&label=LSIO%20Discord&style=flat-square)](https://discord.gg/YWrKVTn)
[![](https://images.microbadger.com/badges/version/linuxserver/minisatip.svg)](https://microbadger.com/images/linuxserver/minisatip "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/linuxserver/minisatip.svg)](https://microbadger.com/images/linuxserver/minisatip "Get your own version badge on microbadger.com")
![Docker Pulls](https://img.shields.io/docker/pulls/linuxserver/minisatip.svg)
![Docker Stars](https://img.shields.io/docker/stars/linuxserver/minisatip.svg)
[![Build Status](https://ci.linuxserver.io/buildStatus/icon?job=Docker-Pipeline-Builders/docker-minisatip/master)](https://ci.linuxserver.io/job/Docker-Pipeline-Builders/job/docker-minisatip/job/master/)
[![](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/minisatip/latest/badge.svg)](https://lsio-ci.ams3.digitaloceanspaces.com/linuxserver/minisatip/latest/index.html)

[Minisatip](https://github.com/catalinii/minisatip) is a multi-threaded satip server version 1.2 that runs under Linux and it was tested with DVB-S, DVB-S2, DVB-T, DVB-T2, DVB-C, DVB-C2, ATSC and ISDB-T cards.

[![minisatip](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/minisatip-icon.png)](https://github.com/catalinii/minisatip)

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`. We utilise the docker manifest for multi-platform awareness. More information is available from docker [here](https://github.com/docker/distribution/blob/master/docs/spec/manifest-v2-2.md#manifest-list). 

Simply pulling `linuxserver/minisatip` should retrieve the correct image for your arch, but you can also pull specific arch images via tags.

The architectures supported by this image are:

| Architecture | Tag |
| :----: | --- |
| x86-64 | amd64-latest |
| arm64 | arm64v8-latest |
| armhf | arm32v6-latest |


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=minisatip \
  -e PUID=1001 \
  -e PGID=1001 \
  -e TZ=Europe/London \
  -e RUN_OPTS=<parameter> \
  -p 8875:8875 \
  -p 554:554 \
  -p 1900:1900/udp \
  -v </path/to/appdata/config>:/config \
  --device /dev/dvb:/dev/dvb \
  --restart unless-stopped \
  linuxserver/minisatip
```

### Additional runtime parameters

In some cases it might be necessary to start minisatip with additional parameters, for example to configure a unicable LNB. Add the parameters you need and restart the container. Be sure to have the right parameters set as adding the wrong once might lead to the container not starting correctly.
For a list of minisatip parameters visit [Minisatip](https://github.com/catalinii/minisatip) page.


### docker-compose

Compatible with docker-compose v2 schemas.

```
---
version: "2"
services:
  minisatip:
    image: linuxserver/minisatip
    container_name: minisatip
    environment:
      - PUID=1001
      - PGID=1001
      - TZ=Europe/London
      - RUN_OPTS=<parameter>
    volumes:
      - </path/to/appdata/config>:/config
    ports:
      - 8875:8875
      - 554:554
      - 1900:1900/udp
    devices:
      - /dev/dvb:/dev/dvb
    mem_limit: 4096m
    restart: unless-stopped
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 8875` | Status Page WebUI |
| `-p 554` | RTSP Port |
| `-p 1900/udp` | App Discovery |
| `-e PUID=1001` | for UserID - see below for explanation |
| `-e PGID=1001` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-e RUN_OPTS=<parameter>` | Specify specific run params for minisatip |
| `-v /config` | Configuration files and minisatip data |
| `--device /dev/dvb` | For passing through Tv-cards |

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1001` and `PGID=1001`, to find yours use `id user` as below:

```
  $ id username
    uid=1001(dockeruser) gid=1001(dockergroup) groups=1001(dockergroup)
```


&nbsp;
## Application Setup

Best used in conjunction with [tvheadend](https://github.com/linuxserver/docker-tvheadend)

There is no setup per se, other than adding your cards for passthrough.

You can then use your cards as DVB inputs in apps such as tvheadend.



## Support Info

* Shell access whilst the container is running: `docker exec -it minisatip /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f minisatip`
* container version number 
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' minisatip`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' linuxserver/minisatip`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.  
  
Below are the instructions for updating containers:  
  
### Via Docker Run/Create
* Update the image: `docker pull linuxserver/minisatip`
* Stop the running container: `docker stop minisatip`
* Delete the container: `docker rm minisatip`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* Start the new container: `docker start minisatip`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Compose
* Update the image: `docker-compose pull linuxserver/minisatip`
* Let compose update containers as necessary: `docker-compose up -d`
* You can also remove the old dangling images: `docker image prune`

## Versions

* **20.02.19:** - Fix run options.
* **11.02.19:** - Add pipeline logic and multi arch.
* **28.08.18:** - Rebase to Alpine 3.8.
* **13.12.17:** - Rebase to Alpine 3.7.
* **28.05.17:** - Rebase to Alpine 3.6.
* **08.02.17:** - Rebase to Alpine 3.5 and only compile libs in dvb-apps.
* **14.10.16:** - Add version layer information.
* **18.09.16:** - Add support for Common Interface.
* **11.09.16:** - Add layer badges to README.
* **28.08.16:** - Add badges to README.
* **15.08.16:** - Initial Release.
