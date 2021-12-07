# Introduction
This repository builds a docker container with the pre-requisites for the [FSDA Toolbox](http://rosa.unipr.it/fsda.html). In addition it has an automated github action to build the docker container to `ghcr.io` so that users can simply pull the pre-built container.

## Getting Pre-Built Images
```
docker pull ghcr.io/josmartin/fsda-dockerfile:r2021b
```

## Running Container
This container is built directly `FROM` [`mathworks/matlab`](https://hub.docker.com/r/mathworks/matlab) and has all the same command-line arguments.

## Build from Repo
To build this container clone the repository and execute

```
docker build -t fsda-dockerfile --build-args FSDA_RELEASE=2021b .
```

You can specify previous versions by modifying the `FSDA_RELEASE=2021b` build argument.

# github Automated Build
The automated build procedure is driven when a specific tag of the form `R*` is pushed to the repository. To build the image for `FSDA` release `2021b` the `main` branch should have the tag `R2021b` applied. If the tag already exists then it should be deleted and re-applied. The most general set of commands to trigger a build of a version are
```
git tag -d R2021b
git push origin --delete R2021b

git tag -a R2021b -m "Tagging for an R2021b build"
git push origin --tags
````
