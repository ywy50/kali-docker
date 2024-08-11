#!/bin/bashrun.sh
sudo docker run -it --rm -v $(pwd)/volume:/opt/app/volume ywy50/kali-tools:latest /bin/bash