# homebrew-epics
Homebrew tap for EPICS things

## Installation

Works on OS X [Homebrew](http://brew.sh/) and Linux with [linuxbrew](http://linuxbrew.sh/).

1. First install brew or linuxbrew
2. Then

```bash
$ brew tap klauer/epics
$ brew install epics-motor
```

## areaDetector

To install areaDetector, you may need to tap `homebrew/science` as well.

```bash
$ brew tap homebrew/science

# install R2-4 with the following:
$ brew install epics-area-detector2 --HEAD

# install R1-9-1 with the following:
$ brew install epics-area-detector1
```
