# OpenDingux beta buildroot on macOS

The OpenDingux beta buildroot requires a case-sensitive file system. Unfortunately, the default macOS file system is not case-sensitive.

## Requirements

I'm pretty sure you just need `git` and `docker` installed, everything else should be stock macOS. You also need to bump Docker's Memory up from 2GB to 8GB. That setting can be found under Docker.app's Preferences > Resources > Advanced.

## Getting started

Clone this repo, then `cd odbuildroot-macos && make`. Done.

## What this repo does

First it creates a 20GB case-sensitive sparse disk image named `od-docker` and mounts it. (This has been enough to build OpenDingux beta for the RS-90 with ~5GB to spare.) Then it unzips `od-docker.zip` into the root of the new volume. (This directory is zipped to avoid confusion, we only want to be working on the case-sensitive disk image. It just contains a Dockerfile and a Makefile to configure it.) Then it clones the OpenDingux buildroot repo into its `workspace/` directory and starts up a Debian docker image with all the prerequisites. Finally, it opens the `workspace/` folder in the Finder and a shell in the docker image where you can build OpenDingux.

All this happens the first time you run `make` from this directory. Subsequent times it will only do what's necessary to get you back into the shell. When you're done with the shell you can `exit` and eject the disk image. Or leave it mounted. Whichever. It will all spring back to life the next time you run `make` from this directory.

Anything in the `workspace/` folder is accessible to both macOS and the Debian docker image. So use your favorite native IDE to make changes then just popover to the terminal to build as needed.

## Tips for building OpenDingux beta

Once in the shell (you'll see a prompt like `root@bc605c7d06c9:~/workspace#`), the first thing you need to do is `cd` into `buildroot/` and run `CONFIG=<PLATFORM> ./rebuild.sh` and then go do something else. For a while. We're talking hours. With any luck when you get back (or wake up) you'll have an `output/<PLATFORM>/` folder in the repo, and inside that an `images/` folder containing an OpenDingux beta installer named something like `<PLATFORM>-update-<YYYY>-<MM>-<DD>.opk`.

After that initial build, you can make changes and run `make` from the `output/<PLATFORM>/` folder and it will take minutes instead of hours to rebuild. You'll make those changes in the `output/<PLATFORM>/` folder itself. (Usually to files in the `build/` or `target/` folders therein.) But beware, unless you copy those changes up to the corresponding files in `board/opendingux/` they will be overwritten the next time you run `CONFIG=<PLATFORM> ./rebuild.sh`.

Good luck!